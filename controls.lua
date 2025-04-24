
local function keys(s,d)
  if s == 'w' then
    state.player.dir.y = state.player.dir.y - d
  elseif s == 's' then
    state.player.dir.y = state.player.dir.y + d
  elseif s == 'a' then
    state.player.dir.x = state.player.dir.x - d
  elseif s == 'd' then
    state.player.dir.x = state.player.dir.x + d
  else
    return
  end
  state.player.dir:toUnit()
end

function love.keypressed(k,s,isrepeat)
  if isrepeat then return end
  if s == 'space' then state.player:startDash(); return end
  keys(s,1)
end

function love.keyreleased(k,s)
  keys(s,-1)
end
