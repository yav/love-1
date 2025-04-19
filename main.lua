require "lib.Vec2D"
require "state"

function love.load()
  state:init()
end




function love.draw()
  state.player:draw()
  state.other:draw()
  love.graphics.print(tostring(state.player:overlaps(state.other)), 200, 200)
end