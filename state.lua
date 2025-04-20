require "lib.Rectangle"
require "lib.Vec2D"
require "lib.Map2D"
require "lib.CollisionMap"

--- @class State
state = {}

local function addObj(r)
  state.obstacles:addObj(r, r)
  local os = state.objs
  os[#os + 1] = r
end

function love.load()
  state.player    = Rectangle:new(Vec2D:new(0,0), Vec2D:new(50,60))
  state.speed     = 200
  state.dir       = Vec2D:new(0,0)
  state.color     = {r = 255,g = 255,b = 0}

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
  local spd = state.speed * dt
  local delta = state.dir:clone():scale(spd)
  if delta == Vec2D.zero then return end
  local new = state.player.topLeft:clone():add(delta)
  local newR = Rectangle:new(new, state.player.dim)
  local blocks = state.obstacles:findCollisions(newR)
  for _,r in ipairs(blocks) do
    newR.topLeft:add(state.player:clash(r,spd))
  end
  -- if state.obstacles:hasCollisions(newR) then return end
  state.player = newR
end







