require "lib.Rectangle"
require "lib.Vec2D"
require "lib.Map2D"
require "lib.CollisionMap"
require "lib.Color"
require "Entity"
require "Enemy"


--- @class State
state = {}

local function addObj(r)
  state.obstacles:addObj(r, r)
  local os = state.objs
  os[#os + 1] = r
end

function love.load()
  local player      = Entity:new()
  player.bbox.dim   = Vec2D:new(50,60)
  player.speed      = 200
  player.color      = Color:new(255,0,255,1)
  state.player      = player

  local es = {}
  for i = 1,10 do
    local e = Enemy:new()
    e.move.bbox.topLeft = Vec2D:new(200+40*i,200)
    es[#es+1] = e
  end
  state.enemies = es

  state.movingMap = CollisionMap:new(100)
  state.obstacles = CollisionMap:new(100)
  state.objs      = {}
  for i = 1,10 do
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
  for _,e in ipairs(state.enemies) do
    e:update(dt)
  end
end







