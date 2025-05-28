-- Escribe codigo
require "library"
prepareWindow()

pointA_X = 0
pointA_Y = 0
pointB_X = 0
pointB_Y = 0

creature = drawCreature(layer, "griphon", 256, 256)
pointA = drawCreature(layer, "blue_pin", pointA_X, pointA_Y)
pointB = drawCreature(layer, "green_pin", pointB_X, pointB_Y)
movementSpeed = 25

mousePositionX = nil
mousePositionY = nil

function onUpdate(seconds)
    creaturePositionX, creaturePositionY = getPropPosition(creature)
    -- Empieza tu código
    local dirX = pointB_X - creaturePositionX
    local dirY = pointB_Y - creaturePositionY
    
    local distance = math.sqrt(dirX * dirX + dirY * dirY)
    
    if distance > 0 then
        local normX = dirX / distance
        local normY = dirY / distance

        creaturePositionX = creaturePositionX + normX * movementSpeed * seconds
        creaturePositionY = creaturePositionY + normY * movementSpeed * seconds
    end
    -- Termina tu código
    setPropPosition(creature, creaturePositionX, creaturePositionY)
    setPropPosition(pointA, pointA_X, pointA_Y)
    setPropPosition(pointB, pointB_X, pointB_Y)
end

function onClickLeft(down)
    print("Clicked Left")
    if down then
        -- Escribe tu código para el botón izquierdo
        pointA_X = mousePositionX
        pointA_Y = mousePositionY
        -- Termina tu código
        setPropPosition(creature, pointA_X, pointA_Y)
    end
end

function onClickRight(down)
    print("Clicked Right")
    if down then
        -- Escribe tu código para el botón derecho
        pointB_X = mousePositionX
        pointB_Y = mousePositionY
        -- Termina tu código
        setPropPosition(creature, pointA_X, pointA_Y)
    end
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

