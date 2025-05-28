-- Escribe codigo
require "library"
require "xml"
require "enemigo"
require "enemigoHuidizo"
prepareWindow()

mousePositionX = nil
mousePositionY = nil

-- Define tus variables globales
criaturas = {}
enemigos  = {}
---- Fin de tus variables globales

-- Define tus funciones y llamadas
function getValue(node, tag)
    for _, child in ipairs(node) do
        if child.tag == tag then
            return child[1]
        end
    end
    return nil
end

function getChild(node, tag)
    for _, child in ipairs(node) do
        if child.tag == tag then
            return child
        end
    end
    return nil
end

function loadCriaturas(xml)
    for _, criaturaNode in ipairs(xml) do
        local name = getValue(criaturaNode, "name")
        local texture = getValue(criaturaNode, "texture")
        local sizeNode = getChild(criaturaNode, "size")
        local sizeX = tonumber(getValue(sizeNode, "X"))
        local sizeY = tonumber(getValue(sizeNode, "Y"))

        criaturas[name] = {
            texture = texture,
            size = Vector:new(sizeX, sizeY)
        }
    end
end

function loadMapa(xml)
    for _, criaturaNode in ipairs(xml) do
        local name = getValue(criaturaNode, "name")
        local posNode = getChild(criaturaNode, "position")
        local posX = tonumber(getValue(posNode, "X"))
        local posY = tonumber(getValue(posNode, "Y"))

        local tipo = criaturas[name]
		if tipo then
            local pos = Vector:new(posX, posY)
            local tam = tipo.size
            local tex = tipo.texture

            local nuevo
            if name == "mago" then
                nuevo = EnemigoHuidizo:new(tex, pos, tam, 40)
            else
                nuevo = Enemigo:new(tex, pos, tam, 30)
            end
            table.insert(enemigos, nuevo)			
		end
    end
end

local xmlCriaturas = readXML("criaturas.xml")
local xmlMapa = readXML("map.xml")

loadCriaturas(xmlCriaturas)
loadMapa(xmlMapa)

for _, enemigo in ipairs(enemigos) do
    enemigo:draw()
end

-- Fin de tus funciones

function onUpdate(seconds)
end

function onClickLeft(down)
    print("Clicked Left")
    if not down then
        -- Escribe tu código para el botón izquierdo
		for _, enemigo in ipairs(enemigos) do
            if enemigo:contiene(mousePositionX, mousePositionY) then
                enemigo:recibirDanio()
                break
            end
        end
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