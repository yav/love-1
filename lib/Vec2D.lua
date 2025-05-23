--- @class Vec2D
--- @field x number
--- @field y number
Vec2D = {}
local meta = { __index = Vec2D }


--- Create a new vector.
--- @param x number
--- @param y number
--- @return Vec2D
function Vec2D:new(x,y)
  local obj = { x = x or 0, y = y or 0 }
  setmetatable(obj,meta)
  return obj
end

--- The coordinates of the vector.
--- @return number x
--- @return number y
function Vec2D:parts()
  return self.x,self.y
end

--- The vector (0,0)
Vec2D.zero = Vec2D:new(0,0)

--- In place addition.
--- @param v Vec2D
--- @return Vec2D self
function Vec2D:add(v)
  self.x = self.x + v.x
  self.y = self.y + v.y
  return self
end

--- In place subtraction.
--- @param v Vec2D
--- @return Vec2D self
function Vec2D:sub(v)
  self.x = self.x - v.x
  self.y = self.y - v.y
  return self
end

--- Scale this vector.
--- @param s number
--- @return Vec2D self
function Vec2D:scale(s)
  self.x = s * self.x
  self.y = s * self.y
  return self
end

--- Make this a unit vector.
--- @return Vec2D self
function Vec2D:toUnit()
    local n = self:len()
    if not n == 0 then
      self:scale(1/n)
    end
    return self
end

--- [const] Returns the square of the length of the vector.
--- @return number
function Vec2D:len2()
  return self.x * self.x + self.y * self.y
end

--- [const] Returns the length of the vector.
--- @return number
function Vec2D:len()
  return math.sqrt(self:len2())
end

--- [const] Returns a new vector with the same value as this one.
--- @return Vec2D
function Vec2D:clone()
  return Vec2D:new(self.x,self.y)
end

--- [const] Returns the square of the distance to another vector.
--- @param v Vec2D
--- @return number
function Vec2D:distance2To(v)
  return self:clone():sub(v):len2()
end

--- [const] Returns the distance to another vector.
--- @param v Vec2D
--- @return number
function Vec2D:distanceTo(v)
  return math.sqrt(self:distance2To(v))
end

--- Round down cordinates.
--- @return Vec2D self
function Vec2D:floor()
  self.x = math.floor(self.x)
  self.y = math.floor(self.y)
  return self
end

--- Round up cordinates
--- @return Vec2D self
function Vec2D:ceil()
  self.x = math.ceil(self.x)
  self.y = math.ceil(self.y)
  return self
end

function meta:__tostring()
  return "(" .. self.x .. ", " .. self.y .. ")"
end

function meta:__eq(v)
  return self.x == v.x and self.y == v.y
end
