require "lib.Vec2D"
require "lib.Rectangle"
require "lib.EffectTimer"
require "lib.Color"
require "Moving"
require "Dashing"


--- @class Entity
--- @field color     Color
--- @field move      Moving
--- @field dash      Dashing
Entity = {}
local meta = { __index = Entity }

function Entity:new()
  local obj = {}
  obj.color = Color:new(255,0,0,1)
  obj.move  = Moving:new()
  obj.dash  = Dashing:new(obj.move)
  return setmetatable(obj, meta)
end

function Entity:startDash()
  self.dash:start()
end

function Entity:draw()
  love.graphics.setColor(self.color:unpack())
  self.move.bbox:draw()
  self.dash:draw()
end

--- @param dt number Amount of time that has passed
function Entity:update(dt)
  local dashing = self.dash:update(dt)
  if not self.move:isMoving() then return end

  if not dashing then self.move:removeMovingMap() end

  local mult = dt
  if dashing then mult = mult * self.dash.mult end
  local speed = self.move:getSpeed(mult)
  self.move:update(speed, true, not dashing)

  if not dashing then self.move:addMovingMap() end
end

