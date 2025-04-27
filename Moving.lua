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
  
end