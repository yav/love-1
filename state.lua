require "lib.Rectangle"
require "lib.Vec2D"
require "lib.Map2D"
require "lib.CollisionMap"

--- @class State
state = {}

local function addObj(r)
  state.obstacles:addObj(r, {})
  local os = state.objs
  os[#os + 1] = r
end

function love.load()
  state.player    = Rectangle:new(Vec2D:new(50,60), Vec2D:new(50,60))
  state.speed     = 75
  state.dir       = Vec2D:new(0,0)
  state.color     = {r = 255,g = 255,b = 0}

  state.obstacles = CollisionMap:new(100)
  state.objs      = {}
  addObj(Rectangle:new(Vec2D:new(17,27), Vec2D:new(100,57)))
end


function love.update(dt)
  local delta = state.dir:clone():scale(state.speed * dt)
  state.player.topLeft:add(delta)
  if delta == Vec2D.zero then return end
  if state.obstacles:hasCollisions(state.player) then
    state.color = {r = 255,g = 0,b = 0}
  else
    state.color = {r = 255,g = 255,b = 255}
  end
end







