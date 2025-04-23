require "state"
require "controls"

local function focusPlayer()
  local w,h = love.graphics.getDimensions()
  local pt = state.player.bbox
  local x,y = pt.topLeft:parts()
  local pw,ph = pt.dim:parts()
  love.graphics.translate((w - pw)/2-x,(h-ph)/2-y)
end

function love.draw()
  focusPlayer()
  love.graphics.setColor(255,255,0)
  for _,r in ipairs(state.objs) do
    r:draw()
  end

  love.graphics.setColor(255,0,0)
  for _,e in ipairs(state.enemies) do
    e.move.bbox:draw()
  end

  local c = state.color
  love.graphics.setColor(c.r,c.g,c.b)
  state.player.bbox:draw()
end