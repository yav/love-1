require "state"
require "controls"

function love.draw()
  love.graphics.setColor(255,255,0)
  for _,r in ipairs(state.objs) do
    r:draw()
  end

  love.graphics.setColor(255,0,0)
  state.enemy.move.bbox:draw()

  local c = state.color
  love.graphics.setColor(c.r,c.g,c.b)
  state.player.bbox:draw()
end