require "state"
require "controls"

function love.draw()
  local clash = state.player:overlaps(state.other)
  if clash then
    love.graphics.setColor(255,0,0)
  else
    love.graphics.setColor(255,255,0)
  end
  state.player:draw()
  state.other:draw()
end