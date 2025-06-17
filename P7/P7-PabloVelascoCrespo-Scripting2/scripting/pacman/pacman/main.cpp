#include "Pacman.hpp"
#include "lua.hpp"

lua_State* L = nullptr;

int coin_score = 50;
int powerup_score = 5000;
int powerup_duration = 5;
float powerup_speed_multiplier = 2.0f;
int powerup_color_r = 255, powerup_color_g = 255, powerup_color_b = 0;
int bronces_para_plata = 100;
int platas_para_oro = 5;
float vida = 1.5f;
const float max_vida = 1.5f;
int num_coins = 0;

#include <iostream>
Pacman* global_pacman = nullptr;

Pacman* checkPacman(lua_State* L) {
  return *(Pacman**)luaL_checkudata(L, 1, "PacmanMeta");
}

int lua_Pacman_new(lua_State* L) {
  Pacman** udata = (Pacman**)lua_newuserdata(L, sizeof(Pacman*));
  *udata = new Pacman();

  luaL_getmetatable(L, "PacmanMeta");
  lua_setmetatable(L, -2);

  return 1;
}

int lua_Pacman_setColor(lua_State* L) {
  Pacman* p = checkPacman(L);
  int r = (int)lua_tonumber(L, 2);
  int g = (int)lua_tonumber(L, 3);
  int b = (int)lua_tonumber(L, 4);
  p->setColor(r, g, b);
  return 0;
}

int lua_Pacman_setSpeedMultiplier(lua_State* L) {
  Pacman* p = checkPacman(L);
  float m = (float)lua_tonumber(L, 2);
  p->setSpeedMultiplier(m);
  return 0;
}

int lua_Pacman_setPowerUpTime(lua_State* L) {
  Pacman* p = checkPacman(L);
  int t = (int)lua_tonumber(L, 2);
  p->setPowerUpTime(t);
  return 0;
}

void registerPacmanClass(lua_State* L) {
  luaL_newmetatable(L, "PacmanMeta");

  lua_pushcfunction(L, lua_Pacman_setColor);
  lua_setfield(L, -2, "setColor");

  lua_pushcfunction(L, lua_Pacman_setSpeedMultiplier);
  lua_setfield(L, -2, "setSpeedMultiplier");

  lua_pushcfunction(L, lua_Pacman_setPowerUpTime);
  lua_setfield(L, -2, "setPowerUpTime");

  lua_pushvalue(L, -1);
  lua_setfield(L, -2, "__index");

  lua_pop(L, 1);

  lua_register(L, "Pacman_new", lua_Pacman_new);
}

void loadGameConfig(lua_State* L) {
  luaL_dofile(L, "lua/pacman.lua");

  lua_getglobal(L, "coin_score");
  if (lua_isnumber(L, -1)) coin_score = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);

  lua_getglobal(L, "powerup_score");
  if (lua_isnumber(L, -1)) powerup_score = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);

  lua_getglobal(L, "powerup_duration");
  if (lua_isnumber(L, -1)) powerup_duration = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);

  lua_getglobal(L, "powerup_speed_multiplier");
  if (lua_isnumber(L, -1)) powerup_speed_multiplier = (float)lua_tonumber(L, -1);
  lua_pop(L, 1);

  lua_getglobal(L, "bronze_medal_score");
  if (lua_isnumber(L, -1)) bronces_para_plata = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);

  lua_getglobal(L, "powerup_color");
  if (lua_istable(L, -1)) {
    lua_rawgeti(L, -1, 1); powerup_color_r = (int)lua_tonumber(L, -1); lua_pop(L, 1);
    lua_rawgeti(L, -1, 2); powerup_color_g = (int)lua_tonumber(L, -1); lua_pop(L, 1);
    lua_rawgeti(L, -1, 3); powerup_color_b = (int)lua_tonumber(L, -1); lua_pop(L, 1);
  }
  lua_pop(L, 1);
}

void getColorFromLuaByLives(float lives, int& r, int& g, int& b) {
  lua_getglobal(L, "getPowerUpColorByLives");
  if (!lua_isfunction(L, -1)) {
    lua_pop(L, 1);
    return;
  }

  lua_pushnumber(L, lives);
  if (lua_pcall(L, 1, 1, 0) != 0) {
    lua_pop(L, 1);
    return;
  }

  if (lua_istable(L, -1)) {
    lua_rawgeti(L, -1, 1); r = (int)lua_tonumber(L, -1); lua_pop(L, 1);
    lua_rawgeti(L, -1, 2); g = (int)lua_tonumber(L, -1); lua_pop(L, 1);
    lua_rawgeti(L, -1, 3); b = (int)lua_tonumber(L, -1); lua_pop(L, 1);
  }
  lua_pop(L, 1);
}

bool pacmanEatenCallback(int& score, bool& muerto) {
  vida -= 0.5f;
  muerto = vida < 0.0f;
  return true;
}

bool coinEatenCallback(int& score) {
  ++num_coins;
  score = num_coins * coin_score;
  return true;
}

bool ghostEatenCallback(int& score) {
  return false;
}

bool powerUpEatenCallback(int& score) {
  int r, g, b;
  getColorFromLuaByLives(vida, r, g, b);

  if (global_pacman) {
    global_pacman->setSpeedMultiplier(powerup_speed_multiplier);
    global_pacman->setColor(r, g, b);
    global_pacman->setPowerUpTime(powerup_duration);
  }

  score += powerup_score;
  return true;
}

bool powerUpGone() {
  if (global_pacman) {
    global_pacman->setColor(255, 0, 0);
    global_pacman->setSpeedMultiplier(1.0f);
  }
  return true;
}

bool pacmanRestarted(int& score) {
  score = 0;
  num_coins = 0;
  vida = max_vida;
  return true;
}

bool computeMedals(int& oro, int& plata, int& bronce, int score) {
  plata = score / bronces_para_plata;
  bronce = score % bronces_para_plata;

  oro = plata / platas_para_oro;
  plata = plata % platas_para_oro;

  return true;
}

bool getLives(float& vidas) {
  vidas = vida;
  return true;
}

bool setImmuneCallback() { return true; }
bool removeImmuneCallback() { return true; }

bool frameCallback(float time) {
  loadGameConfig(L);
  return false;
}

bool InitGame() {
  L = luaL_newstate();
  luaL_openlibs(L);
  registerPacmanClass(L);
  loadGameConfig(L);

  lua_getglobal(L, "createGlobalPacman");
  if (lua_isfunction(L, -1)) {
    if (lua_pcall(L, 0, 1, 0) == 0) {
      global_pacman = *(Pacman**)lua_touserdata(L, -1);
    }
    else
    {
      const char* err = lua_tostring(L, -1);
      printf("Lua error: %s\n", err);
      lua_pop(L, 1);
      return false;
    }
    lua_pop(L, 1);
  }

  return true;
}

bool EndGame() {
  if (L) {
    lua_close(L);
    L = nullptr;
  }
  delete global_pacman;
  global_pacman = nullptr;
  return true;
}
