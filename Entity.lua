require "lib.Color"
require "Moving"
require "Dashing"
require "Team"

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
  self.move:draw()
  self.dash:draw()
end

function Entity:getBBox()
  return self.move.bbox
end

--- @param dt number Amount of time that has passed
function Entity:update(dt,owner)
  local dashing = self.dash:update(dt)
  if not self.move:isMoving() then return end

  local bbox  = self:getBBox()
  local team  = owner:getTeam()
  team:removeObj(bbox, owner)

  local mult = dt
  if dashing then mult = mult * self.dash.mult end
  local speed = self.move:getSpeed(mult)


  local vel   = self.move.dir:clone():scale(speed)
  local newP  = bbox.topLeft:clone():add(vel)
  local newR  = Rectangle:new(newP, bbox.dim)

  -- Collisions with static
  local blocks = state.obstacles:findCollisions(newR)
  for _,r in ipairs(blocks) do
    newP:add(bbox:clash(r,speed))
  end

  if dashing then
    local dashAbility = owner.dashAbility
    if dashAbility then
      local otherTeam = state.playerTeam
      if team == otherTeam then otherTeam = state.enemyTeam end

      -- dash through opponent
      local enemyMovs = otherTeam.collision:findCollisions(newR)
      for _,ent in ipairs(enemyMovs) do
        owner.dashAbility(ent)
      end
    end
  else

    if team == state.enemyTeam then

      -- enemy/enemy collision
      local enemyMovs = state.enemyTeam.collision:findCollisions(newR)
      for _,ent in ipairs(enemyMovs) do
        newP:add(bbox:clash(ent:getBBox(),speed))
      end

      -- enemy/player collisions
      local playerMovs = state.playerTeam.collision:findCollisions(newR)
      for _,ent in ipairs(playerMovs) do
        newP:add(bbox:clash(ent:getBBox(),speed))
      end

    else

      -- player/enemy collisions
      local enemyMovs = state.enemyTeam.collision:findCollisions(newR)
      for _,ent in ipairs(enemyMovs) do
        newP:add(bbox:clash(ent:getBBox(),speed))
      end
    end
  end

  self.move.bbox = newR
  team:addObj(newR, owner)
end

