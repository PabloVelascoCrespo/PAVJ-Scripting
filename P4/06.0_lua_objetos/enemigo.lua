require "vector"

Enemigo  = {}
Enemigo .__index = Enemigo 

-- Constructor
function Enemigo :new(texture, position, size, vida)
	local e = setmetatable({}, self)
    e.texture = texture
    e.position = position
    e.size = size
    e.maxVida = vida
    e.vida = vida
    e.muerto = false
	e.image = nil
    return e
end

function Enemigo:draw()
    self.image = addImage(self.texture, self.position.x, self.position.y, self.size.x, self.size.y)
end


function Enemigo:contiene(pX, pY)
    return pX >= self.position.x and pX <= self.position.x + self.size.x and
           pY >= self.position.y and pY <= self.position.y + self.size.y
end

function Enemigo:recibirDanio()
    if self.muerto then return end
    self.vida = self.vida - 10
    print("¡Daño recibido! Vida restante: " .. self.vida)

    if self.vida <= 0 then
        self.muerto = true
        self.size = self.size:scale(0.5)
		removeImage(self.image)
		self:draw()
        print("¡Enemigo muerto! Tamaño reducido a " .. tostring(self.size))
    end
end