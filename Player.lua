Player = {}
local meta = { __index = Player }

function Player:new()
  local obj = {}

  local player          = Entity:new()
  player.move.bbox.dim  = Vec2D:new(100,60)
  player.move.speed     = 200
  player.color          = Color:new(255,0,255,1)
  obj.ent               = player
  obj.dashAbility = function (other)
    print("Player " .. tostring(obj) .. " dashed through " .. tostring(other))
  end

  return  setmetatable(obj, meta)
end

-- @param dt number
function Player:update(dt)
  self.ent:update(dt, self)
end

function Player:getBBox()
  return self.ent:getBBox()
end

function Player:getTeam()
  return state.playerTeam
end

function Player:draw()
  self.ent:draw()
end