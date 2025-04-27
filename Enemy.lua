require "lib.Vec2D"
require "lib.Rectangle"
require "lib.EffectTimer"
require "lib.Color"
require "Entity"


Enemy = {}
local meta = { __index = Enemy }

function Enemy:new()
  local obj = {}

  local ent = Entity:new()
  ent.bbox.dim = Vec2D:new(32,32)
  ent.speed = 150
  ent.dir = Vec2D:new(1,1)
  ent.color = Color:new(255,0,0,1)
  obj.move = ent

  obj.nextAction = EffectTimer:new(0.5,1)
  obj.nextAction.onReady = function ()
    obj.move.dir:scale(-1)
    obj.nextAction:start()
  end
  obj.nextAction:start()

  return setmetatable(obj,meta)
end

function Enemy:update(dt)
  self.nextAction:update(dt)
  self.move:update(dt)
end