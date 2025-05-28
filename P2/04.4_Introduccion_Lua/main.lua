-- Escribe codigo
require "library"
prepareWindow()

mousePositionX = nil
mousePositionY = nil

-- Define tus variables globales
criaturas = {}
vida_inicial = 25
-- Termina tu definicion de variables

function onUpdate(seconds)
end

function onClickLeft(down)
    print("Clicked Left")
    if not down then
        -- Escribe tu código para el botón izquierdo
        local criatura = addCreature("griphon", mousePositionX, mousePositionY)
        table.insert(criaturas, {
            obj = criatura,
            x = mousePositionX,
            y = mousePositionY,
            vida = vida_inicial
        })
        -- Termina tu código
    end
end

function onClickRight(down)
    print("Clicked Right")
    creatureSizeX, creatureSizeY = getCreatureSize("griphon")
    if not down then
        -- Escribe tu código para el botón derecho
        for i = #criaturas, 1, -1 do
            local c = criaturas[i]

            if mousePositionX >= c.x and mousePositionX <= c.x + creatureSizeX and
               mousePositionY >= c.y and mousePositionY <= c.y + creatureSizeY then
                c.vida = c.vida - 5
                print("Vida restante: " .. c.vida)

                if c.vida <= 0 then
                    removeCreature(c.obj)
                    table.remove(criaturas, i)
                    print("¡Criatura eliminada!")
                end

                break -- solo una criatura afectada por clic
            end
        end
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

