require "state"
require "controls"

function love.draw()

  local grid = state.gridSize
  local playerGrid = state.player:toGrid(grid)

  love.graphics.setColor(255,255,255)
  for row = 1, 50 do
    local r = row - 1
    for col = 1, 50 do
      local c = col - 1
      if playerGrid:contains(Vec2D:new(c,r)) then
        love.graphics.setColor(0,0,255)
      else
        love.graphics.setColor(255,255,255)
      end
      love.graphics.rectangle("line", c * grid, r * grid, grid - 2, grid - 2)
    end
  end

  local c = state.color
  love.graphics.setColor(c.r,c.g,c.b)
  state.player:draw()
  love.graphics.setColor(255,255,0)
  for _,r in ipairs(state.objs) do
    r:draw()
  end

end