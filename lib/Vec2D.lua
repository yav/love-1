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

--- In place addition.  Returns `self`.
--- @param v Vec2D
--- @return Vec2D
function Vec2D:add(v)
  self.x = self.x + v.x
  self.y = self.y + v.y
  return self
end

--- In place subtraction.  Returns `self`.
--- @param v Vec2D
--- @return Vec2D
function Vec2D:sub(v)
  self.x = self.x - v.x
  self.y = self.y - v.y
  return self
end

--- Scale this vector.  Returns `self`.
--- @param s number
--- @return Vec2D
function Vec2D:scale(s)
  self.x = s * self.x
  self.y = s * self.y
  return self
end

--- Make this a unit vector. Returns `self.`
--- @return Vec2D
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

--- [const] Compute the coordinates of this vector on a grid.
--- @param size number Size of ach square on the grid
--- @return Vec2D coordinates on the grid (0 based)
function Vec2D:gridLoc(size)
  return Vec2D:new(math.floor(self.x/size), math.floor(self.y/size))
end

--- [const] Is this vector one of the given ones
--- @param xs table of Vec2D
--- @return boolean
function Vec2D:isOneOf(xs)
  for i = 1, #xs do
    if self == xs[i] then return true end
  end
  return false
end

function meta:__tostring()
  return "(" .. self.x .. ", " .. self.y .. ")"
end

function meta:__eq(v)
  return self.x == v.x and self.y == v.y
end
