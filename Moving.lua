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

function Moving:addMovingMap()
  state.movingMap:addObj(self.bbox, self)
end

function Moving:removeMovingMap()
  state.movingMap:removeObj(self.bbox, self)
end


-- @param speed number Use this speed for the update (`dt` is part of this)
-- @param checkStatic boolean Check for static collisions?
-- @param checkEnt boolean Check for collisions with other entitites
function Moving:update(speed, checkStatic, checkEnt)
  local bbox  = self.bbox
  local vel   = self.dir:clone():scale(speed)
  local newP  = bbox.topLeft:clone():add(vel)
  local newR  = Rectangle:new(newP, bbox.dim)

  -- Collisions with static
  if checkStatic then
    local blocks = state.obstacles:findCollisions(newR)
    for _,r in ipairs(blocks) do
      newP:add(bbox:clash(r,speed))
    end
  end

  -- Collisions with other entities
  if checkEnt then
    local movs = state.movingMap:findCollisions(newR)
    for _,ent in ipairs(movs) do
      newP:add(bbox:clash(ent.bbox,speed))
    end
  end

  self.bbox = newR
end

