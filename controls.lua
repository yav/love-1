
-- XXX: don't modify player position directly.
local function keys(s,d)
  local pos = state.player.ent.move.dir
  if s == 'w' then
    pos.y = pos.y - d
  elseif s == 's' then
    pos.y = pos.y + d
  elseif s == 'a' then
    pos.x = pos.x - d
  elseif s == 'd' then
    pos.x = pos.x + d
  else
    return
  end
  pos:toUnit()
end

function love.keypressed(k,s,isrepeat)
  if isrepeat then return end
  if s == 'space' then state.player.ent:startDash(); return end
  keys(s,1)
end

function love.keyreleased(k,s)
  keys(s,-1)
end
