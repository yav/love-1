require "lib.Vec2D"

--- @class Rectangle
--- @field topLeft Vec2D
--- @field dim     Vec2D
Rectangle = {}
local meta = { __index = Rectangle }

--- Create a new rectange.
--- @param topLeft Vec2D  Coordinate of top-left corner.
--- @param dim     Vec2D  Dimensions of the rectangle.
--- @return Rectangle
function Rectangle:new(topLeft,dim)
  local obj = { topLeft = topLeft, dim = dim }
  return setmetatable(obj,meta)
end


--- [const] Check if this rectangle is entirely to the left of another.
--- @param r Rectangle
--- @return boolean
function Rectangle:isLeftOf(r)
  return self.topLeft.x + self.dim.x < r.topLeft.x
end

--- [const] Check if this rectangle is entirely to the right of another.
--- @param r Rectangle
--- @return boolean
function Rectangle:isRightOf(r)
  return r:isLeftOf(self)
end

--- [const] Check if this rectangle is entirely above another.
--- @param r Rectangle
--- @return boolean
function Rectangle:isAbove(r)
  return self.topLeft.y + self.dim.y < r.topLeft.y
end

--- [const] Check if this rectangle is entirely below another.
--- @param r Rectangle
--- @return boolean
function Rectangle:isBelow(r)
  return r:isAbove(self)
end

--- [const] Check if this rectangle overlaps another.
--- @param r Rectangle
--- @return boolean
function Rectangle:overlaps(r)
  return not (self:isLeftOf(r) or
              self:isRightOf(r) or
              self:isAbove(r) or
              self:isBelow(r))
end

--- Compute the reaction if this rectangle is about to clash into another.
--- @param r Rectangle
--- @param speed number
--- @return Vec2D
function Rectangle:clash(r,speed)
  local dx = 0
  local dy = 0
  if self:isLeftOf(r) then dx = dx - speed
  elseif self:isRightOf(r) then dx = dx + speed end
  if self:isAbove(r) then dy = dy - speed
  elseif self:isBelow(r) then dy = dy + speed end
  return Vec2D:new(dx,dy)
end

--- Return the corrdinates of the bottom roght correr.
--- @return Vec2D
function Rectangle:bottomRight()
  return self.topLeft:clone():add(self.dim)
end

--- [const] Do we contain the given point.
--- @param v Vec2D
--- @return boolean
function Rectangle:contains(v)
  local lim = self:bottomRight()
  return self.topLeft.x <= v.x and v.x < lim.x and 
         self.topLeft.y <= v.y and v.y < lim.y
end

--- [const] Draw a rectangle
function Rectangle:draw()
  love.graphics.rectangle("fill",self.topLeft.x, self.topLeft.y, self.dim.x, self.dim.y)
end

--- [const] Compute a bounding rectangle on a grid.
--- @param size number Size of grid squares.
--- @return Rectangle r In grid coordinates.
function Rectangle:toGrid(size)
  local s = 1 / size
  local start = self.topLeft:clone():scale(s):floor()
  local lim   = self:bottomRight():scale(s):ceil()
  return Rectangle:new(start,lim:sub(start))
end

function meta:__tostring()
  return "{ loc = " .. tostring(self.topLeft) .. ", dim = " .. tostring(self.dim) .. " }"
end

function meta:__eq(r)
  return self.topLeft == r.topLeft and self.dim == r.dim
end