-- Escribe codigo
require "library"
prepareWindow()

carta, carta_image = drawImage(layer, "cards\\A_C.png", 256, 256, 79, 123)
mousePositionX = 0
mousePositionY = 0

-- Variables auxiliares
palo_actual = nil -- Puede ser "C", "D", "T", "P"

function onUpdate(seconds)
end

function onClickLeft(down)
    if down then
        print("Clicked Left")
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
    image_file = nil
    key_pressed = convertKeyToChar(key)
    -- Escribe tu código para gestion de teclado
        if not key_pressed then return end

    key_pressed = string.lower(key_pressed) -- para ignorar mayúsculas
    print("Key pressed: ", key_pressed, " Down: ", down)

    if down then
        if key_pressed == "c" then
            palo_actual = "C"
        elseif key_pressed == "d" then
            palo_actual = "D"
        elseif key_pressed == "t" then
            palo_actual = "T"
        elseif key_pressed == "p" then
            palo_actual = "P"
        elseif palo_actual ~= nil then
            local valor = nil
            if key_pressed >= "2" and key_pressed <= "9" then
                valor = key_pressed
            elseif key_pressed == "j" then
                valor = "J"
            elseif key_pressed == "q" then
                valor = "Q"
            elseif key_pressed == "k" then
                valor = "K"
            end

            if valor then
                image_file = "cards\\" .. valor .. "_" .. palo_actual .. ".png"
                palo_actual = nil
            end
        end
    else
        if key_pressed == "c" or key_pressed == "d" or key_pressed == "t" or key_pressed == "p" then
            palo_actual = nil
        end
    end
    -- Termina tu código
    
    if image_file then
        setImage(carta_image, image_file)
    end
end



callbackConfiguration(onClickLeft, onClickRight, onMouseMove, onKeyPress)
mainLoop()

