--- @class PeriodicTimer
--- @field period number
--- @field time number
--- @field event function
PeriodicTimer = {}
local meta = { __index = PeriodicTimer }

function PeriodicTimer:new(period, f)
  local obj = {}
  obj.period = period
  obj.event = f
  obj.time = 0
  return setmetatable(obj, meta)
end

--- Fire the function, then start he counter from the period.
function PeriodicTimer:start()
  self.event()
  self.time = self.period
end

--- Stop the timer.  If restarted will start with a new period.
function PeriodicTimer:stop()
  self.time = 0
end

function PeriodicTimer:update(dt)
  local t = self.time
  if t == 0 then return end -- not running
  t = t - dt
  if t <= 0 then
    local p = self.period
    repeat
      self.event()
      t = t + p
    until t > 0
    if t > p then t = t - p end
  end
  self.time = t
end