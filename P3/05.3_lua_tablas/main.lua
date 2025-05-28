-- Escribe codigo
require "library"
prepareWindow()

mousePositionX = nil
mousePositionY = nil

-- Define tus variables globales    
local creatureTextures = {
    griphon = "creatures/gryphon.png",
    mage   = "creatures/mage.png",
    grunt  = "creatures/grunt.png",
    peon   = "creatures/peon.png",
    dragon = "creatures/dragon.png"
}
local creatureMap = {
    {nombre = "griphon", x = 100, y = 150},
    {nombre = "mage",    x = 200, y = 100},
    {nombre = "grunt",   x = 300, y = 200},
    {nombre = "peon",    x = 400, y = 250},
    {nombre = "dragon",  x = 500, y = 100}
}
-- Fin de tus variables globales

-- Define tus funciones y llamadas
function addCreature(nombre, x, y)
    local ruta = creatureTextures[nombre]
    if ruta then
        return addImage(ruta, x, y)
    end
end
-- Fin de tus funciones

for _, criatura in ipairs(creatureMap) do
    addCreature(criatura.nombre, criatura.x, criatura.y)
end

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

