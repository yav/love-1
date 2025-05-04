require "lib.Vec2D"
require "lib.Rectangle"

--- @class Moving           Things that move around
--- @field speed number     How fast we are moving
--- @field dir   Vec2D      Unit vector in the direction we are moving
--- @field bbox  Rectangle  Our location and size
Moving = {}
local meta = { __index = Moving }

function Moving:new()
  local obj = {}
  obj.speed = 0
  obj.dir   = Vec2D.zero:clone()
  obj.bbox  = Rectangle:new(Vec2D.zero:clone(), Vec2D.zero:clone())
  return setmetatable(obj, meta)
end

function Moving:draw()
  self.bbox:draw()
end

--- @return Vec2D
function Moving:position()
  return self.bbox.topLeft
end

--- @return boolean
function Moving:isMoving()
  return self.speed > 0 and not (self.dir == Vec2D.zero)
end

--- @param mult number
--- @return number speed
function Moving:getSpeed(mult)
  return mult * self.speed
end



