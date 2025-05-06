require "lib.Vec2D"
require "lib.EffectTimer"
require "lib.Color"
require "Entity"


--- @class Enemy
--- @field ent Entity
--- @field nextAction EffectTimer
Enemy = {}
local meta = { __index = Enemy }

--- @returns Enemy
function Enemy:new()
  local obj = {}

  local ent = Entity:new()
  ent.move.bbox.dim = Vec2D:new(32,32)
  ent.move.speed = 150
  ent.move.dir = Vec2D:new(1,1)
  ent.color = Color:new(255,0,0,1)
  obj.ent = ent

  obj.nextAction = EffectTimer:new(0.5,1)
  obj.nextAction.onReady = function ()
    obj.ent.move.dir:scale(-1)
    obj.nextAction:start()
  end
  obj.nextAction:start()

  return setmetatable(obj,meta)
end

function Enemy:getBBox()
  return self.ent:getBBox()
end

function Enemy:getTeam()
  return state.enemyTeam
end

--- @param dt number
function Enemy:update(dt)
  self.nextAction:update(dt)
  self.ent:update(dt, self)
end

function Enemy:draw()
  self.ent:draw()
end


function Enemy:shot(b)
  self.ent:shot(b)
end