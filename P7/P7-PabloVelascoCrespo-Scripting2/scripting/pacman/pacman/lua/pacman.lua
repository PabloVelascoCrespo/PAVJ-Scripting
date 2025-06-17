-- Creamos una instancia global
function createGlobalPacman()
    return Pacman_new()
end

powerup_score = 5500
powerup_duration = 5
powerup_speed_multiplier = 2.5
powerup_color = { 255, 255, 0 }
bronze_medal_score = 100
coin_score = 2500

function getPowerUpColorByLives(lives)
    if lives >= 1.5 then
        return {255, 0, 0}
    elseif lives >= 1.0 then
        return {255, 128, 0}
    elseif lives >= 0.5 then
        return {0, 255, 0}
    else
        return {0, 0, 255}
    end
end
