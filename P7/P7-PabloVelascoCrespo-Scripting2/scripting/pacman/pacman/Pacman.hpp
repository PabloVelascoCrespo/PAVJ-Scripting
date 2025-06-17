#pragma once

struct Pacman {
  float speed_multiplier = 1.0f;
  int r = 255, g = 255, b = 255;
  int powerup_duration = 5;

  void setColor(int rr, int gg, int bb);
  void setSpeedMultiplier(float s);
  void setPowerUpTime(int duration);
};
