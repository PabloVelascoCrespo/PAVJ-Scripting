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

function onPacmanEaten(lives)
    lives = lives - 0.5
    local muerto = lives < 0
    return lives, muerto
end

function onCoinEaten(num_coins)
    num_coins = num_coins + 1
    local coin_score = 2500
    return num_coins, num_coins * coin_score
end

function onGhostEaten()
    return 10000
end

function onPowerUpEaten(lives)
    local speed = 2.5
    local duration = 5
    local color = getPowerUpColorByLives(lives)
    setPacmanSpeedMultiplier(speed)
    setPowerUpTime(duration)
    setPacmanColor(color[1], color[2], color[3])
    return 5500
end

function onPowerUpGone()
    setPacmanColor(255, 0, 0)
    setPacmanSpeedMultiplier(1.0)
end

function onFrame(dt)
end

function onPacmanRestarted()
    return 0, 0 -- score, num_coins
end

function onComputeMedals(score)
    local bronze_per_silver = 100
    local silver_per_gold = 5

    local plata = math.floor(score / bronze_per_silver)
    local bronce = score % bronze_per_silver

    local oro = math.floor(plata / silver_per_gold)
    plata = plata % silver_per_gold

    return oro, plata, bronce
end
