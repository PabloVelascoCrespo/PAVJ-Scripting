require "library"
require "prepare"

-- Define tus variables globales
local square_start_x = 100
local square_start_y = 100
local square_size = 20
-- Termina tu definicion de variables

function pintarPunto(punto)
    -- Rellenar código para pintar un punto en la pantalla
    drawPoint(punto.x, punto.y)
    -- Fin de código
end

function onUpdate(seconds)
end

function onDraw()
    -- Empieza tu código, que debe emplear la funcion pintarPunto
    for y = square_start_y, square_start_y + square_size - 1 do
        for x = square_start_x, square_start_x + square_size - 1 do
            pintarPunto({x = x, y = y})
        end
    end
    -- Termina tu código
end

function onClickLeft(down)
    print("Clicked Left")
    if down then
    end
end

function onClickRight(down)
    print("Clicked Right")
    if down then
    end
end

function onMouseMove(posX, posY)
    --print("Mouse Moved to " .. posX .. ","..posY)
end

function onKeyPress(key, down)
    print("Key pressed: "..key)
end

callbackConfiguration(onClickLeft, onClickRight, onMouseMove, onKeyPress, onDraw, window_layer)
mainLoop()
