#include "Pacman.hpp"
#include <pacman_include.hpp>

void Pacman::setColor(int rr, int gg, int bb) {
  r = rr; g = gg; b = bb;
  setPacmanColor(r, g, b);
}

void Pacman::setSpeedMultiplier(float s) {
  speed_multiplier = s;
  setPacmanSpeedMultiplier(s);
}

void Pacman::setPowerUpTime(int duration) {
  powerup_duration = duration;
  ::setPowerUpTime(duration);
}