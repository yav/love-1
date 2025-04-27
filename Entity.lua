require "lib.Vec2D"
require "lib.Rectangle"
require "lib.EffectTimer"
require "lib.Color"
require "Dashing"


--- @class Entity
--- @field color     Color
--- @field speed     number
--- @field dir       Vec2D
--- @field bbox      Rectangle
--- @field dash      Dashing
Entity = {}
local meta = { __index = Entity }

function Entity:new()
  local obj = {}
  obj.color = Color:new(255,0,0,1)
  obj.speed = 0
  obj.dir   = Vec2D.zero:clone()
  obj.bbox  = Rectangle:new(Vec2D.zero:clone(), Vec2D.zero:clone())
  obj.dash  = Dashing:new()
  return setmetatable(obj, meta)
end

function Entity:startDash()
  self.dash:start()
end

function Entity:draw()
  love.graphics.setColor(self.color:unpack())
  self.bbox:draw()
  self.dash:draw(self.bbox)
end

--- @param dt number
function Entity:update(dt)
  local dashing = self.dash:update(dt, self.bbox.topLeft)
  local speed = dt * self.speed
  if dashing then speed = self.dash.dashMult * speed end

  local delta = self.dir:clone():scale(speed)
  if not (delta == Vec2D.zero) then
    state.movingMap:removeObj(self.bbox, self)
    local newP  = self.bbox.topLeft:clone():add(delta)
    local newR  = Rectangle:new(newP, self.bbox.dim)

    local blocks = state.obstacles:findCollisions(newR)
    for _,r in ipairs(blocks) do
      newP:add(self.bbox:clash(r,speed))
    end

    if not dashing then
      local movs = state.movingMap:findCollisions(newR)
      for _,r in ipairs(movs) do
        newP:add(self.bbox:clash(r.bbox,speed))
      end
    end
    self.bbox = newR
    state.movingMap:addObj(self.bbox, self)
  end
end

