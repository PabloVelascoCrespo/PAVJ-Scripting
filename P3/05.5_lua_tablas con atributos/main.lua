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
function loadCriaturas(xml)
    for _, criaturaNode in ipairs(xml) do
        local name = criaturaNode.attr["name"]
        local texture = criaturaNode.attr["texture"]
        local sizeX = tonumber(criaturaNode.attr["sizex"])
        local sizeY = tonumber(criaturaNode.attr["sizey"])

        criaturas[name] = {
            texture = texture,
            size = {x = sizeX, y = sizeY}
        }
    end
end

function loadMapa(xml)
    for _, criaturaNode in ipairs(xml) do
        local name = criaturaNode.attr["name"]
        local posX = tonumber(criaturaNode.attr["x"])
        local posY = tonumber(criaturaNode.attr["y"])
        
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