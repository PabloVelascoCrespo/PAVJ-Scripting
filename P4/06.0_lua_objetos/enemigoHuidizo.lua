require "vector"

EnemigoHuidizo = setmetatable({}, {__index = Enemigo})
EnemigoHuidizo.__index = EnemigoHuidizo

function EnemigoHuidizo:new(texture, position, size, vida)
    return Enemigo.new(self, texture, position, size, vida)
end

function EnemigoHuidizo:recibirDanio()
    if self.muerto then return end
    self.vida = self.vida - 10
    print("¡Daño recibido! Vida restante: " .. self.vida)

    if self.vida <= 0 then
        self.muerto = true
        self.size = self.size:scale(0.5)
        removeImage(self.image)
		self:draw()
        print("¡Enemigo huidizo muerto! Tamaño reducido a " .. tostring(self.size))
    elseif self.vida < self.maxVida / 2 then
        local maxX = 800 - self.size.x
        local maxY = 600 - self.size.y
        self.position = Vector:new(math.random(0, maxX), math.random(0, maxY))
        removeImage(self.image)
		self:draw()
        print("¡Huye a nueva posición! " .. tostring(self.position))
    end
end
