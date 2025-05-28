Vector = {}
Vector.__index = Vector

-- Constructor
function Vector:new(x, y)
	local v = setmetatable({}, self)
	v.x = x or 0
	v.y = y or 0
	return v
end

-- Suma
function Vector.__add(a, b)
	return Vector:new(a.x + b.x, a.y + b.y)
end

-- Resta
function Vector.__sub(a, b)
	return Vector:new(a.x - b.x, a.y - b.y)
end

-- Producto escalar
function Vector:dot(other)
	return self.x * other.x + self.y * other.y
end

-- Longitud del vector
function Vector:length()
	return math.sqrt(self.x * self.x + self.y)
end

-- Normalizar el vector
function Vector:normalize()
	local len = self:length()
	if len == 0 then
		return Vector:new(0, 0)
	end
	return Vector:new(self.x / len, self.y /len)
end

-- Escalar
function Vector:scale(factor)
	return Vector:new(self.x * factor, self.y * factor)
end

-- Imprimir
function Vector:__tostring()
    return "(" .. self.x .. ", " .. self.y .. ")"
end