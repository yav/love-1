require "lib.Vec2D"
require "lib.Rectangle"
require "lib.EffectTimer"
require "lib.Color"
require "Moving"
require "Dashing"



--- @class Entity
--- @field color     Color
--- @field move      Moving
--- @field dash      Dashing
Entity = {}
local meta = { __index = Entity }

function Entity:new()
  local obj = {}
  obj.color = Color:new(255,0,0,1)
  obj.move  = Moving:new()
  obj.dash  = Dashing:new()
  return setmetatable(obj, meta)
end

function Entity:startDash()
  self.dash:start()
end

function Entity:draw()
  love.graphics.setColor(self.color:unpack())
  self.move.bbox:draw()
  self.dash:draw(self.move.bbox)
end

--- @param dt number
function Entity:update(dt)
  local bbox = self.move.bbox
  local dashing = self.dash:update(dt, bbox.topLeft)
  local speed = dt * self.move.speed
  if dashing then speed = self.dash.dashMult * speed end

  local delta = self.move.dir:clone():scale(speed)
  if not (delta == Vec2D.zero) then
    state.movingMap:removeObj(bbox, self)
    local newP  = bbox.topLeft:clone():add(delta)
    local newR  = Rectangle:new(newP, bbox.dim)

    local blocks = state.obstacles:findCollisions(newR)
    for _,r in ipairs(blocks) do
      newP:add(bbox:clash(r,speed))
    end

    if not dashing then
      local movs = state.movingMap:findCollisions(newR)
      for _,ent in ipairs(movs) do
        newP:add(bbox:clash(ent.move.bbox,speed))
      end
    end
    self.move.bbox = newR
    state.movingMap:addObj(newR, self)
  end
end

