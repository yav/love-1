require "state"
require "controls"

function love.draw()

  local grid = 20
  local playerGrid = state.player:gridLocs(grid)
  
  love.graphics.setColor(255,255,255)
  for row = 1, 50 do
    local r = row - 1
    for col = 1, 50 do
      local c = col - 1
      if Vec2D:new(c,r):isOneOf(playerGrid) then
        love.graphics.setColor(0,0,255)
      else
        love.graphics.setColor(255,255,255)
      end
      love.graphics.rectangle("line", c * grid, r * grid, grid - 2, grid - 2)
    end
  end

  if state.player:overlaps(state.other) then
    love.graphics.setColor(255,0,0)
  else
    love.graphics.setColor(255,255,0)
  end
  state.player:draw()
  state.other:draw()

end