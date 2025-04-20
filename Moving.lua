require "lib.Vec2D"
require "lib.Rectangle"

--- @class Moving
--- @field speed number
--- @field dir   Vec2D
--- @field bbox  Rectangle
Moving = {}
local meta = { __index = Moving }

function Moving:new()
  local obj = {}
  obj.speed = 0
  obj.dir   = Vec2D.zero:clone()
  obj.bbox  = Rectangle:new(Vec2D.zero:clone(), Vec2D.zero:clone())
  return setmetatable(obj, meta)
end

--- @param dt number
function Moving:update(dt)
  local spd   = self.speed * dt
  local delta = self.dir:clone():scale(spd)
  if delta == Vec2D.zero then return end

  local newP  = self.bbox.topLeft:clone():add(delta)
  local newR  = Rectangle:new(newP, self.bbox.dim)

  local blocks = state.obstacles:findCollisions(newR)
  for _,r in ipairs(blocks) do
    newP:add(self.bbox:clash(r,spd))
  end
  self.bbox = newR
end

