require "lib.CollisionMap"
require "lib.Rectangle"

--- @class Team
--- @field collision CollisionMap
--- @field bullets table of Bullet
--- @field members table
Team = {}
local meta = { __index = Team }

function Team:new()
  local obj = {}
  obj.members   = {}
  obj.collision = CollisionMap:new(100)
  obj.bullets   = {}
  return setmetatable(obj, meta)
end

function Team:addMember(obj)
  self.members[obj] = true
  self:addObj(obj:getBBox(), obj)
end

function Team:removeMember(obj)
  self:removeObj(obj:getBBox(), obj)
  self.members[obj] = nil
end

--- @param r   Rectangle
--- @param obj any
function Team:addObj(r,obj)
  self.collision:addObj(r,obj)
end

--- @param r Rectangle
--- @param obj any
function Team:removeObj(r,obj)
  self.collision:removeObj(r,obj)
end


--- @param dt number
function Team:update(dt)
  for obj,_ in pairs(self.members) do
    obj:update(dt)
  end
  --- XXX: bullets
end

function Team:draw()
  for obj,_ in pairs(self.members) do
    obj:draw()
  end
  --- XXX: bullets
end