-- Escribe codigo
require "library"
prepareWindow()

mousePositionX = nil
mousePositionY = nil

-- Define tus variables globales
local creatureTextures = {
    griphon = "creatures/gryphon.png",
    mage = "creatures/mage.png",
    grunt = "creatures/grunt.png",
    peon = "creatures/peon.png",
    dragon = "creatures/dragon.png"
}
-- Fin de tus variables globales

-- Define tus funciones y llamadas
function addCreature(nombre)
    return addImage(creatureTextures[nombre])
end
-- Fin de tus funciones

addCreature("dragon")


function onUpdate(seconds)
end

function onClickLeft(down)
    print("Clicked Left")
    if not down then
        -- Escribe tu código para el botón izquierdo
        -- Termina tu código
    end
end

function onClickRight(down)
    print("Clicked Right")
    if not down then
        -- Escribe tu código para el botón derecho
        -- Termina tu código
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

