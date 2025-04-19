require "lib.Rectangle"
require "lib.Vec2D"

--- @class State
--- @field player Rectangle
--- @field other  Rectangle
state = {}

function love.load()
  state.player = Rectangle:new(Vec2D:new(50,60), Vec2D:new(50,60))
  state.speed  = 75
  state.dir    = Vec2D:new(0,0)
  state.other  = Rectangle:new(Vec2D:new(40,20), Vec2D:new(32,32))
end

function love.update(dt)
  local delta = state.dir:clone():scale(state.speed * dt)
  state.player.topLeft:add(delta)
end







