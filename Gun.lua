require "lib.Vec2D"
require "lib.PeriodicTimer"
require "Bullet"

--- @class Gun 
--- @field dir Vec2D
--- @field bulletSpeed number
--- @field bulletLifetime number
--- @field firing PeriodicTimer
Gun = {}
local meta = { __index = Gun }


function Gun:new(owner)
  local obj = {}
  obj.dir = Vec2D:new(1,0)
  obj.bulletSpeed = 500
  obj.bulletLifetime = 2
  obj.bulletDamage = 5
  local function shoot()
    local m = Moving:new()
    m.speed = obj.bulletSpeed
    m.dir   = obj.dir:clone()
    m.bbox  = Rectangle:new(owner:getBBox().topLeft:clone(), Vec2D:new(16,16))
    Bullet:new(owner:getTeam(), m, obj.bulletLifetime, obj.bulletDamage)
  end
  obj.firing = PeriodicTimer:new(0.5,shoot)
  return setmetatable(obj, meta)
end

--- @param dir Vec2D
function Gun:aim(dir)
  self.dir = dir
end

function Gun:startShooting()
  self.firing:start()
end

function Gun:stopShooting()
  self.firing:stop()
end

--- @param dt number
function Gun:update(dt)
  self.firing:update(dt)
end