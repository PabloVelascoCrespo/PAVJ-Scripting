#include <pacman_include.hpp>
#include "lua.hpp"

lua_State* L = nullptr;

const float max_vida = 1.5f;
float vida = max_vida;
int num_coins = 0;

void loadGameConfig(lua_State* L)
{
  luaL_dofile(L, "lua/pacman.lua");
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
{
  lua_getglobal(L, "onPacmanEaten");
  lua_pushnumber(L, vida);

  if (lua_pcall(L, 1, 2, 0) != 0) {
    lua_pop(L, 2);
    return false;
  }

  vida = (float)lua_tonumber(L, -2);
  muerto = lua_toboolean(L, -1);
  lua_pop(L, 2);
  return true;
}

bool coinEatenCallback(int& score)
{
  lua_getglobal(L, "onCoinEaten");
  lua_pushnumber(L, num_coins);
  if (lua_pcall(L, 1, 2, 0) != 0) {
    lua_pop(L, 2);
    return false;
  }

  num_coins = (int)lua_tonumber(L, -2);
  score = (int)lua_tonumber(L, -1);
  lua_pop(L, 2);
  return true;
}

bool ghostEatenCallback(int& score)
{
  lua_getglobal(L, "onGhostEaten");
  if (lua_pcall(L, 0, 1, 0) != 0) {
    lua_pop(L, 1);
    return false;
  }

  score += (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  return true;
}

bool powerUpEatenCallback(int& score)
{
  lua_getglobal(L, "onPowerUpEaten");
  lua_pushnumber(L, vida);
  if (lua_pcall(L, 1, 1, 0) != 0) {
    lua_pop(L, 1);
    return false;
  }

  score += (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  return true;
}

bool powerUpGone()
{
  lua_getglobal(L, "onPowerUpGone");
  if (lua_pcall(L, 0, 0, 0) != 0) {
    lua_pop(L, 1);
    return false;
  }
  return true;
}

bool frameCallback(float time)
{
  lua_getglobal(L, "onFrame");
  lua_pushnumber(L, time);
  if (lua_pcall(L, 1, 0, 0) != 0) {
    lua_pop(L, 1);
    return false;
  }
  return false;
}

bool pacmanRestarted(int& score)
{
  lua_getglobal(L, "onPacmanRestarted");
  if (lua_pcall(L, 0, 2, 0) != 0) {
    lua_pop(L, 2);
    return false;
  }

  score = (int)lua_tonumber(L, -2);
  num_coins = (int)lua_tonumber(L, -1);
  vida = max_vida;
  lua_pop(L, 2);
  return true;
}

bool computeMedals(int& oro, int& plata, int& bronce, int score)
{
  lua_getglobal(L, "onComputeMedals");
  lua_pushnumber(L, score);
  if (lua_pcall(L, 1, 3, 0) != 0) {
    lua_pop(L, 3);
    return false;
  }

  oro = (int)lua_tonumber(L, -3);
  plata = (int)lua_tonumber(L, -2);
  bronce = (int)lua_tonumber(L, -1);
  lua_pop(L, 3);
  return true;
}

bool getLives(float& vidas)
{
  vidas = vida;
  return true;
}

bool setImmuneCallback() { return true; }
bool removeImmuneCallback() { return true; }


int lua_SetPacmanSpeedMultiplier(lua_State* L) {
  float speed = (float)lua_tonumber(L, 1);
  setPacmanSpeedMultiplier(speed); // Esta es tu función de C++
  return 0; // no devuelve nada a Lua
}

int lua_SetPowerUpTime(lua_State* L) {
  int duration = (int)lua_tonumber(L, 1);
  setPowerUpTime(duration);
  return 0;
}

int lua_SetPacmanColor(lua_State* L) {
  int r = (int)lua_tonumber(L, 1);
  int g = (int)lua_tonumber(L, 2);
  int b = (int)lua_tonumber(L, 3);
  setPacmanColor(r, g, b);
  return 0;
}


bool InitGame()
{
  L = luaL_newstate();
  luaL_openlibs(L);
  lua_register(L, "setPacmanSpeedMultiplier", lua_SetPacmanSpeedMultiplier);
  lua_register(L, "setPowerUpTime", lua_SetPowerUpTime);
  lua_register(L, "setPacmanColor", lua_SetPacmanColor);
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
