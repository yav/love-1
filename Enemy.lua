require "lib.Vec2D"
require "lib.Rectangle"
require "lib.EffectTimer"
require "Entity"

Enemy = {}
local meta = { __index = Enemy }

function Enemy:new()
  local obj = {}

  local move = Entity:new()
  move.bbox.dim = Vec2D:new(32,32)
  move.speed = 150
  move.dir = Vec2D:new(1,1)
  obj.move = move

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