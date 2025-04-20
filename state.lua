require "lib.Rectangle"
require "lib.Vec2D"
require "lib.Map2D"
require "lib.CollisionMap"
require "Moving"
require "Enemy"

--- @class State
state = {}

local function addObj(r)
  state.obstacles:addObj(r, r)
  local os = state.objs
  os[#os + 1] = r
end

function love.load()
  local player      = Moving:new()
  player.bbox.dim   = Vec2D:new(50,60)
  player.speed      = 200
  state.player      = player

  state.enemy       = Enemy:new()
  state.enemy.move.bbox.topLeft = Vec2D:new(200,200)

  state.color     = {r = 255,g = 0,b = 255}

  state.obstacles = CollisionMap:new(100)
  state.objs      = {}
  for i = 1,30 do
    local sz = math.random(4,16)
    local x  = math.random(100,800)
    local y  = math.random(100,600)
    local pos = Vec2D:new(x,y)
    local dim = Vec2D:new(sz,sz)
    addObj(Rectangle:new(pos,dim))
  end
end


function love.update(dt)
  state.player:update(dt)
  state.enemy:update(dt)
end







