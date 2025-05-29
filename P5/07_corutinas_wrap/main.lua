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
    grifo = { texture = "creatures/gryphon.png", size = {x = 92, y = 92}, vida = 60 },
    mago = { texture = "creatures/mage.png", size = {x = 64, y = 64}, vida = 51 },
    grunt = { texture = "creatures/grunt.png", size = {x = 72, y = 72}, vida = 50 },
    peon = { texture = "creatures/peon.png", size = {x = 32, y = 32}, vida = 5 },
    dragon = { texture = "creatures/dragon.png", size = {x = 128, y = 128}, vida = 200 },
}
local criaturaIterador = nil
-- Fin de tus variables globales

-- Define tus funciones
function crearIteradorCriaturas()
    local nombresValidos = {}
    for nombre, datos in pairs(criaturas) do
        if datos.vida > 50 then
            table.insert(nombresValidos, nombre)
        end
    end

    -- Mezclar aleatoriamente la lista
    for i = #nombresValidos, 2, -1 do
        local j = math.random(i)
        nombresValidos[i], nombresValidos[j] = nombresValidos[j], nombresValidos[i]
    end

    return coroutine.wrap(function()
        for _, nombre in ipairs(nombresValidos) do
            coroutine.yield(nombre)
        end
    end)
end

criaturaIterador = crearIteradorCriaturas()

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
        local nombre = criaturaIterador()
        if nombre then
            pintarCriatura(nombre, mousePositionX, mousePositionY)
        else
            criaturaIterador = crearIteradorCriaturas()
            local siguiente = criaturaIterador()
            if siguiente then
                pintarCriatura(siguiente, mousePositionX, mousePositionY)
            end
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
