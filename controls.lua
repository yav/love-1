
local function keys(s,d)
  if s == 'w' then
    state.dir.y = state.dir.y - d
  elseif s == 's' then
    state.dir.y = state.dir.y + d
  elseif s == 'a' then
    state.dir.x = state.dir.x - d
  elseif s == 'd' then
    state.dir.x = state.dir.x + d
  else
    return
  end
  state.dir:toUnit()
end

function love.keypressed(k,s,isrepeat)
  if isrepeat then return end
  keys(s,1)
end

function love.keyreleased(k,s)
  keys(s,-1)
end
