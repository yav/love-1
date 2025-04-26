require "lib.Vec2D"
require "lib.Rectangle"
require "lib.EffectTimer"

--- @class Moving
--- @field speed     number
--- @field dir       Vec2D
--- @field bbox      Rectangle
--- @field dashTimer EffectTimer
--- @field dashTrace table
Moving = {}
local meta = { __index = Moving }

function Moving:new()
  local obj = {}
  obj.speed = 0
  obj.dashTimer = EffectTimer:new(0.25,1)
  obj.dashTrace = {}
  obj.dashTimer.onFinished = function () obj.dashTrace = {} end

  obj.dir   = Vec2D.zero:clone()
  obj.bbox  = Rectangle:new(Vec2D.zero:clone(), Vec2D.zero:clone())
  return setmetatable(obj, meta)
end

function Moving:startDash()
  self.dashTimer:start()
end

function Moving:draw()
  for i,pos in ipairs(self.dashTrace) do
    love.graphics.setColor(state.color.r, state.color.g, state.color.b, i/#self.dashTrace)
    Rectangle:new(pos,self.bbox.dim):draw()
  end
  self.bbox:draw()
  if not self.dashTimer:isActive() then
    local x,y = self.bbox.topLeft:parts()
    local w,h = self.bbox.dim:parts()
    local len = 2*(w+h) * self.dashTimer:progress()
    love.graphics.setColor(255,255,255)
    local todo = len
    if todo > w then todo = w end
    love.graphics.line(x,y,x+todo,y)
    len = len - todo
    todo = len
    if todo > h then todo = h end
    love.graphics.line(x+w,y,x+w,y+todo)
    len = len - todo
    todo = len
    if todo > w then todo = w end
    love.graphics.line(x+w-todo,y+h,x+w,y+h)
    len = len - todo
    love.graphics.line(x,y+h-len,x,y+h)
  end
end

--- @param dt number
function Moving:update(dt)
  local speed = self.speed
  self.dashTimer:update(dt)
  local dashing = self.dashTimer:isActive()
  if dashing then
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

    if not dashing then
      local movs = state.movingMap:findCollisions(newR)
      for _,r in ipairs(movs) do
        newP:add(self.bbox:clash(r.bbox,spd))
      end
    end
    self.bbox = newR
    state.movingMap:addObj(self.bbox, self)
  end
end

