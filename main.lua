require "state"
require "controls"

local function focusPlayer()
  local w,h = love.graphics.getDimensions()
  local pt = state.player.move.bbox
  local x,y = pt.topLeft:parts()
  local pw,ph = pt.dim:parts()
  love.graphics.translate((w - pw)/2-x,(h-ph)/2-y)
end

function love.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.print("FPS: " .. tostring(love.timer.getFPS()) .. "; WASD to move, Space to dash")
  focusPlayer()
  love.graphics.setColor(255,255,0)
  for _,r in ipairs(state.objs) do
    r:draw()
  end

  for _,e in ipairs(state.enemies) do
    e.ent:draw()
  end
  
  state.player:draw()
end