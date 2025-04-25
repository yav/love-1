require "lib.Vec2D"
require "lib.Rectangle"

--- @class Moving
--- @field speed number
--- @field dir   Vec2D
--- @field bbox  Rectangle
--- @field dashing number   Time left to dash
--- @field dashTrace table
Moving = {}
local meta = { __index = Moving }

function Moving:new()
  local obj = {}
  obj.speed = 0
  obj.dashing = 0
  obj.dashTrace = {}
  obj.dir   = Vec2D.zero:clone()
  obj.bbox  = Rectangle:new(Vec2D.zero:clone(), Vec2D.zero:clone())
  return setmetatable(obj, meta)
end


function Moving:startDash()
  if self.dashing == 0 then self.dashing = 0.25 end
end

function Moving:draw()
  local n = #self.dashTrace
  for i,pos in ipairs(self.dashTrace) do
    love.graphics.setColor(state.color.r, state.color.g, state.color.b, 255 - i * k)
    Rectangle:new(pos,self.bbox.dim):draw()
  end
  self.bbox:draw()
end

--- @param dt number
function Moving:update(dt)
  local speed = self.speed
  local dash  = self.dashing
  if dash > 0 then
    self.dashTrace[#self.dashTrace + 1] = self.bbox.topLeft:clone()
    speed = 3 * speed
  end
  local spd   = speed * dt
  local delta = self.dir:clone():scale(spd)
  if not (delta == Vec2D.zero) then
    state.movingMap:removeObj(self.bbox, self)
    local newP  = self.bbox.topLeft:clone():add(delta)
    local newR  = Rectangle:new(newP, self.bbox.dim)

    local blocks = state.obstacles:findCollisions(newR)
    for _,r in ipairs(blocks) do
      newP:add(self.bbox:clash(r,spd))
    end

    if dash == 0 then
      local movs = state.movingMap:findCollisions(newR)
      for _,r in ipairs(movs) do
        newP:add(self.bbox:clash(r.bbox,spd))
      end
    end
    self.bbox = newR
    state.movingMap:addObj(self.bbox, self)
  end
  if dash > 0 then
    dash = dash - dt
    if dash < 0 then
      dash = -2
      self.dashTrace = {}
    end
  elseif dash < 0 then
    dash = dash + dt
    if dash > 0 then dash = 0 end
  end
  self.dashing = dash
end

