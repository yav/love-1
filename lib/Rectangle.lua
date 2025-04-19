require "lib.Vec2D"

--- @class Rectangle
--- @field topLeft Vec2D
--- @field dim     Vec2D
Rectangle = {}
local meta = { __index = Rectangle }

--- Create a new rectange.
--- @param topLeft Vec2D  Coordinate of top-left corner
--- @param dim     Vec2D  Dimensiosn of the rectangle\
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

--- [const] Draw a rectangle
function Rectangle:draw()
  love.graphics.rectangle("fill",self.topLeft.x, self.topLeft.y, self.dim.x, self.dim.y)
end

--- [const] Compute the corrdinates occupied by this rectangle
--- on a grid of squares of the given size.
--- @param size number Size of each square on a grid
--- @return table _ Vec2D array with the locations on the grid
function Rectangle:gridLocs(size)
  local xs = {}
  local last = self.topLeft:clone():add(self.dim)
  local row = self.topLeft:gridLoc(size)
  while size * row.y < last.y do
    local col = row:clone()
    while size * col.x < last.x do
      xs[#xs+1] = col:clone()
      col.x = col.x + 1
    end
    row.y = row.y + 1
  end

  return xs
end

function meta:__tostring()
  return "{ loc = " .. tostring(self.topLeft) .. ", dim = " .. tostring(self.dim) .. " }"
end

function meta:__equal(r)
  return self.topLeft == r.topLeft and self.dim == r.dim
end