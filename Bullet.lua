require "lib.Vec2D"
require "lib.EffectTimer"
require "Moving"


--- @class Bullet
--- @field damage number
--- @field team Team
--- @field move Moving
--- @field timer EffectTimer
Bullet = {}
local meta = { __index = Bullet }

--- @param team Team
--- @param move Moving
--- @param life number in seconds
--- @param damage number
function Bullet:new(team, move, life, damage)
  local obj = {}
  obj.team = team
  obj.damage = damage
  obj.move = move
  obj.timer = EffectTimer:new(life,0)
  obj.timer.onFinished = function () obj:finished() end
  team:addBullet(obj)
  obj.timer:start()
  return setmetatable(obj, meta)
end

function Bullet:finished()
  self.team:removeBullet(self)
end

function Bullet:getBBox()
  return self.move:getBBox()
end

function Bullet:draw()
  love.graphics.setColor(0,255,0,1)
  self:getBBox():draw()
end

function Bullet:update(dt)
  self.timer:update(dt)
  if not self.timer:isActive() then return end

  local bbox  = self:getBBox()
  local vel   = self.move.dir:clone():scale(self.move:getSpeed(dt))
  local newP  = bbox.topLeft:clone():add(vel)
  local newR  = Rectangle:new(newP, bbox.dim)

  -- Collisions with static
  if state.obstacles:hasCollisions(newR) then
    self:finished()
    return
  end

  -- Collisions with opponents
  local opponnets = state:otherTeam(self.team):findCollisions(newR)
  local done = false
  for _,ent in ipairs(opponnets) do
    ent:shot(self)
    done = true
    --- XXX: piercing bullets
  end
  if done then self:finished(); return end
  self.move.bbox = newR
end