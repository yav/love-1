--- @class Dashing
--- @field dashMult number
--- @field dashTimer EffectTimer
--- @field dashTrace table
Dashing = {}
local meta = { __index = Dashing }


--- @return Dashing
function Dashing:new()
  local obj = {}
  obj.dashTrace = {}
  obj.dashMult  = 3
  obj.dashTimer = EffectTimer:new(0.25,1)
  obj.dashTimer.onFinished = function () obj.dashTrace = {} end
  return setmetatable(obj, meta)
end


function Dashing:start()
  self.dashTimer:start()
end

--- @return boolean
function Dashing:isActive()
  return self.dashTimer:isActive()
end

--- @param dt number  Amount of time that has passed
--- @param loc Vec2D  Location of the object that is dashing
--- @return boolean b Are we currently dashing
function Dashing:update(dt, loc)
  self.dashTimer:update(dt)
  local active = self.dashTimer:isActive()
  if active then
    local t = self.dashTrace
    t[#t + 1] = loc:clone()
  end
  return active
end

--- @param obj Rectangle
function Dashing:draw(obj)
  local n = #self.dashTrace

  local r,g,b,a = love.graphics.getColor()
  for i,pos in ipairs(self.dashTrace) do
    love.graphics.setColor(r, g, b, a * i/n)
    Rectangle:new(pos,obj.dim):draw()
  end

  if not self:isActive() then
    love.graphics.setColor(255,255,255)
    love.graphics.line(obj:outline(self.dashTimer:progress()))
  end

end
