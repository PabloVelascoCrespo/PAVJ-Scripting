-- Escribe codigo
require "library"
prepareWindow()

creature = drawCreature(layer, "griphon", 256, 256)
mousePositionX = 0
mousePositionY = 0
direction = "right"
directionX = 1
directionY = 0

function onUpdate(seconds)
    creaturePositionX, creaturePositionY = getPropPosition(creature)
    -- Empieza tu código para mover a la criatura
    -- creaturePositionX = creaturePositionX + 50 * direction * seconds --P1
    creaturePositionX = creaturePositionX + 50 * directionX * seconds
    creaturePositionY = creaturePositionY + 50 * directionY * seconds
    -- Termina tu código
    setPropPosition(creature, creaturePositionX, creaturePositionY)
end

function onClickLeft(down)
    if down then
        print("Clicked Left")
        creatureSizeX, creatureSizeY = getCreatureSize("griphon")
        creaturePositionX, creaturePositionY = getPropPosition(creature)
        -- Escribe tu código aqui para botón izquierdo ratón
        -- direction = direction * -1 --P1
        if direction == "right" then
            direction = "left"
            directionX = -1
            directionY = 0
        elseif direction == "left" then
            direction = "up"
            directionX = 0
            directionY = 1
        elseif direction == "up" then
            direction = "down"
            directionX = 0
            directionY = -1            
        elseif direction == "down" then
            direction = "right"
            directionX = 1
            directionY = 0
        end
        -- Termina tu código
    end
end

function onClickRight(down)
    print("Clicked Right")
end

function onMouseMove(posX, posY)
    mousePositionX = posX
    mousePositionY = posY
    --print("Mouse Moved to " .. posX .. ","..posY)
end

function onKeyPress(key, down)
    print("Key pressed: "..key)
end



callbackConfiguration(onClickLeft, onClickRight, onMouseMove, onKeyPress)
mainLoop()

