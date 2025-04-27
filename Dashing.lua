--- @class Dashing
--- @field mult  number
--- @field timer EffectTimer
--- @field trace table
--- @field move  Moving  The moving object that we are dashing
Dashing = {}
local meta = { __index = Dashing }


--- @return Dashing
function Dashing:new(mov)
  local obj = {}
  obj.move  = mov
  obj.trace = {}
  obj.mult  = 3
  obj.timer = EffectTimer:new(0.5,1)

  obj.onStart = function ()
    obj.move:removeMovingMap()
  end

  obj.timer.onFinished = function ()
    obj.trace = {}
    obj.move:addMovingMap()
  end
  return setmetatable(obj, meta)
end

--- Start a dash, if ready.
function Dashing:start()
  self.timer:start()
end

--- Are we presently dashing?
--- @return boolean
function Dashing:isActive()
  return self.timer:isActive()
end

--- @param dt number  Amount of time that has passed
--- @return boolean b Are we currently dashing
function Dashing:update(dt)
  self.timer:update(dt)
  local active = self.timer:isActive()
  if active then
    local t = self.trace
    t[#t + 1] = self.move:position():clone()
  end
  return active
end


function Dashing:draw()
  local n = #self.trace
  local obj = self.move.bbox

  local r,g,b,a = love.graphics.getColor()
  for i,pos in ipairs(self.trace) do
    love.graphics.setColor(r, g, b, a * i/n)
    Rectangle:new(pos,obj.dim):draw()
  end

  if not self:isActive() then
    love.graphics.setColor(255,255,255)
    love.graphics.line(obj:outline(self.timer:progress()))
  end

end
