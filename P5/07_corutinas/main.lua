-- Escribe codigo
require "library"
sequences = require "sequence"
window_layer, debug_layer = prepareWindow()

--mySequence = sequences.Sequence:new()

worldSizeX = 1024
worldSizeY = 768

mousePositionX = nil
mousePositionY = nil

-- Define tus variables globales
criaturas = {
    grifo = { texture = "creatures/gryphon.png", size = {x = 92, y = 92}},
    mago = { texture = "creatures/mage.png", size = {x = 64, y = 64}},
    grunt = { texture = "creatures/grunt.png", size = {x = 72, y = 72}},
    peon = { texture = "creatures/peon.png", size = {x = 32, y = 32}},
    dragon = { texture = "creatures/dragon.png", size = {x = 128, y = 128}},
}
local criaturaIterator = nil
-- Fin de tus variables globales

-- Define tus funciones
function crearIteradorCriaturas()
    local nombres  = {}
    for nombre, _ in pairs(criaturas) do
        table.insert(nombres, nombre)
    end

    -- Mezclar aleatoriamente la lista
    for i = #nombres, 2, -1 do
        local j = math.random(i)
        nombres[i], nombres[j] = nombres[j], nombres[i]
    end

    return coroutine.create(function()
        for _, nombres in ipairs(nombres) do
            coroutine.yield(nombres)
        end
    end)
end

criaturaIterator = crearIteradorCriaturas()

function pintarCriatura(nombre, x, y)
    local data = criaturas[nombre]
    if data then
        addImage(data.texture, x, y, data.size.x, data.size.y)
    end
end
-- Fin de tus funciones

function onDraw()
    -- Escribe tu c�digo para pintar pixel a pixel
    
    -- Fin de tu c�digo
end

function onUpdate(seconds)
    -- Escribe tu c�digo para ejecutar cada frame
    -- Fin del c�digo
end

function onClickLeft(down)
    -- Escribe tu c�digo para el click del rat�n izquierdo (down ser� true si se ha pulsado, false si se ha soltado)
    if down and mousePositionX and mousePositionY then
		local success, nombre = coroutine.resume(criaturaIterator)
        if success and nombre then
            pintarCriatura(nombre, mousePositionX, mousePositionY)
        else
            criaturaIterator = crearIteradorCriaturas()
        end
    end
    -- Fin del c�digo
end

function onClickRight(down)
    -- Escribe tu c�digo para el click del rat�n derecho (down ser� true si se ha pulsado, false si se ha soltado)
    if down then
    
    end
    -- Fin del c�digo
end

function onMouseMove(posX, posY)
    mousePositionX = posX
    mousePositionY = posY
    -- Escribe tu c�digo cuando el rat�n se mueve
    
    -- Fin del c�digo
end

function onKeyPress(key, down)
    -- Escribe tu c�digo para tecla pulsada (down ser� true si la tecla se ha pulsado, false si se ha soltado)
    
    -- Fin del c�digo
end

callbackConfiguration(onClickLeft, onClickRight, onMouseMove, onKeyPress, onDraw, debug_layer)
mainLoop()