require "lib.Vec2D"
require "lib.Rectangle"
require "lib.CollisionMap"
require "lib.Color"
require "Entity"
require "Player"
require "Enemy"
require "Team"

--- @class State
state = {}

local function addObj(r)
  state.obstacles:addObj(r, r)
  local os = state.objs
  os[#os + 1] = r
end

function love.load()
  state.playerTeam = Team:new()
  state.enemyTeam  = Team:new()

  state.player = Player:new()
  state.playerTeam:addMember(state.player)

  local es = {}
  for i = 1,10 do
    local e = Enemy:new()
    e.ent.move.bbox.topLeft = Vec2D:new(200+40*i,200)
    state.enemyTeam:addMember(e)
  end

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

--- @param team Team
function state:otherTeam(team)
  if team == self.playerTeam then return self.enemyTeam end
  return self.playerTeam
end

function love.update(dt)
  state.playerTeam:update(dt)
  state.enemyTeam:update(dt)
end







