require "state"
require "controls"

function love.draw()
  local c = state.color
  love.graphics.setColor(255,255,0)
  for _,r in ipairs(state.objs) do
    r:draw()
  end
  love.graphics.setColor(c.r,c.g,c.b)
  state.player:draw()
end