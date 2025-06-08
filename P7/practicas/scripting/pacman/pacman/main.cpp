#include <pacman_include.hpp>
#include "lua.hpp"

lua_State* L = nullptr;

int powerup_color_r = 0, powerup_color_g = 255, powerup_color_b = 0;
int coin_score = 50;
int powerup_score = 5000;
int powerup_duration = 5;
int num_coins = 0;
int platas_para_oro = 5;
int bronces_para_plata = 100;
const float max_vida = 1.5f;
float powerup_speed_multiplier = 2.0f;
float vida = max_vida;


void loadGameConfig(lua_State* L)
{

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

void getColorFromLuaByLives(float lives, int& r, int& g, int& b)
{
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

bool pacmanEatenCallback(int& score, bool& muerto)
{ // Pacman ha sido comido por un fantasma
  vida -= 0.5f;
  muerto = vida < 0.0f;

  return true;
}

bool coinEatenCallback(int& score)
{ // Pacman se ha comido una moneda
  ++num_coins;
  score = num_coins * coin_score;

  return true;
}

bool frameCallback(float time)
{ // Se llama periodicamente cada frame
  loadGameConfig(L);
  return false;
}

bool ghostEatenCallback(int& score)
{ // Pacman se ha comido un fantasma
  return false;
}

bool powerUpEatenCallback(int& score)
{ // Pacman se ha comido un powerUp
  int r, g, b;
  getColorFromLuaByLives(vida, r, g, b);

  setPacmanSpeedMultiplier(powerup_speed_multiplier);
  setPacmanColor(r, g, b);
  setPowerUpTime(powerup_duration);

  score += powerup_score;

  return true;
}

bool powerUpGone()
{ // El powerUp se ha acabado
  setPacmanColor(255, 0, 0);
  setPacmanSpeedMultiplier(1.0f);
  return true;
}

bool pacmanRestarted(int& score)
{
  score = 0;
  num_coins = 0;
  vida = max_vida;

  return true;
}

bool computeMedals(int& oro, int& plata, int& bronce, int score)
{
  plata = score / bronces_para_plata;
  bronce = score % bronces_para_plata;

  oro = plata / platas_para_oro;
  plata = plata % platas_para_oro;

  return true;
}

bool getLives(float& vidas)
{
  vidas = vida;
  return true;
}

bool setImmuneCallback()
{
  return true;
}

bool removeImmuneCallback()
{
  return true;
}

bool InitGame()
{

  L = luaL_newstate();
  luaL_openlibs(L);
  loadGameConfig(L);
  return true;
}

bool EndGame()
{
  if (L) {
    lua_close(L);
    L = nullptr;
  }
  return true;
}