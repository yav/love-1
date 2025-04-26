--- @class EffectTimer
--- @field timer      number
--- @field duration   number
--- @field cooldown   number
--- @field onReady    function   Call this when the cooldown is finished
--- @field onFinished function   Call this when the active effect is finished
EffectTimer = {}
local meta = { __index = EffectTimer }

--- Create a new effect timer.
--- @param duration number
--- @param cooldown number
--- @return EffectTimer
function EffectTimer:new(duration,cooldown)
  local obj     = {}
  obj.timer     = 0
  obj.duration  = duration
  obj.cooldown  = cooldown
  return setmetatable(obj,meta)
end

local function callReady(self)
  if self.onReady then self.onReady() end
end

local function  callFinished(self)
  if self.onFinished then self.onFinished() end
end

--- Start the timer, if ready.
function EffectTimer:start()
  if self.timer == 0 then self.timer = self.duration end
end

--- Set the timer to the ready state.
function EffectTimer:reset()
  if self:isActive() then callFinished(self)
  elseif self:isCooling() then callReady(self) end
  self.timer = 0
end


--- Is the effect curently active?
--- @return boolean
function EffectTimer:isActive()
  return self.timer > 0
end

--- Is the effect currently on cooldown?
--- @return boolean
function EffectTimer:isCooling()
  return self.timer < 0
end

--- Is the effect ready?
--- This means we are not active, and not on cooldown.
--- @return boolean
function EffectTimer:isReady()
  return self.timer == 0
end

--- Return the percantage progress of the timer.
---   * If it is active this is the progress until the
---     end of the effect.
---   * If we are on cooldown, progress toward being ready.
---   * If we are ready, then this returns 1 (i.e. 100%).
--- @return number percentage
function EffectTimer:progress()
  local t = self.timer
  if t > 0 then
    return 1 - t / self.duration
  elseif t < 0 then
    return 1 + t / self.cooldown
  else
    return 1
  end
end

--- Advance the timer by the given amount of timer.
--- @param dt number
function EffectTimer:update(dt)
  local t = self.timer
  if t == 0 then return end
  if t > 0 then
    t = t - dt
    if t <= 0 then
      callFinished(self)
      t = -(self.cooldown + t)
      if t >= 0 then t = 0 end
    end
  else
    t = t + dt
    if t >= 0 then t = 0 end
  end
  self.timer = t
  if t == 0 then callReady(self) end
end

function meta:__tostring()
  local status
  if self:isActive() then
    status = "Active " .. tostring(math.floor(100 * self:progress())) .. "%"
  elseif self:isCooling() then
    status = "Cooling " .. tostring(math.floor(100 * self:progress())) .. "%"
  else
    status = "Ready"
  end
  return "{ " .. status ..
         ", duration = " .. tostring(self.duration) ..
         ", cooldown = " .. tostring(self.cooldown)
end
