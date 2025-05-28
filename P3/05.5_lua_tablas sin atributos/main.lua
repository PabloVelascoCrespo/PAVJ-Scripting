-- Escribe codigo
require "library"
require "xml"
prepareWindow()

mousePositionX = nil
mousePositionY = nil

-- Define tus variables globales
criaturas = {}
mapa = {}
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
            size = {x = sizeX, y = sizeY}
        }
    end
end

function loadMapa(xml)
    for _, criaturaNode in ipairs(xml) do
        local name = getValue(criaturaNode, "name")
        local posNode = getChild(criaturaNode, "position")
        local posX = tonumber(getValue(posNode, "X"))
        local posY = tonumber(getValue(posNode, "Y"))
        
        table.insert(mapa, {
            name = name,
            position = {x = posX, y = posY}
        })
    end
end

function addCreature(name, x, y)
    local creature = criaturas[name]
    if creature then
        addImage(creature.texture, x, y, creature.size.x, creature.size.y)
    end
end

function drawMap()
    for _, instance in ipairs(mapa) do
		addCreature(instance.name, instance.position.x, instance.position.y)
	end
end

local xmlCriaturas = readXML("criaturas.xml")
local xmlMapa = readXML("map.xml")

loadCriaturas(xmlCriaturas)
loadMapa(xmlMapa)

drawMap()
-- Fin de tus funciones

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