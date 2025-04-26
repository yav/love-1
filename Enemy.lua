require "lib.Vec2D"
require "lib.Rectangle"
require "Entity"

Enemy = {}
local meta = { __index = Enemy }

function Enemy:new()
  local move = Entity:new()
  move.bbox.dim = Vec2D:new(32,32)
  move.speed = 150
  move.dir = Vec2D:new(1,1)
  local obj = { move = move, age = 0 }
  return setmetatable(obj,meta)
end

function Enemy:update(dt)
  self.age = self.age + dt
  if self.age > 2 then
    self.age = 0
    self.move.dir:scale(-1)
  end
  self.move:update(dt)
end