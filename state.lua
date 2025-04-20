require "lib.Rectangle"
require "lib.Vec2D"
require "lib.Map2D"

--- @class State
--- @field player Rectangle
--- @field other  Rectangle
state = {}


local function addObj(r)
  local grect = r:toGrid(state.gridSize)
  local lim = grect:bottomRight()
  for x = grect.topLeft.x, lim.x - 1 do
    for y = grect.topLeft.y, lim.y - 1 do
      local os = state.grid:lookupWithDefault(x,y,{})
      os[#os + 1] = r
    end
  end
  local os = state.objs
  os[#os + 1] = r
end

function love.load()
  state.player    = Rectangle:new(Vec2D:new(50,60), Vec2D:new(50,60))
  state.speed     = 75
  state.dir       = Vec2D:new(0,0)
  state.gridSize  = 100
  state.color     = {r = 255,g = 255,b = 0}
  state.grid      = Map2D:new()
  state.objs      = {}
  addObj(Rectangle:new(Vec2D:new(17,27), Vec2D:new(100,57)))
end


function love.update(dt)
  local delta = state.dir:clone():scale(state.speed * dt)
  if delta == Vec2D.zero then return end
  state.player.topLeft:add(delta)
  local grect = state.player:toGrid(state.gridSize)
  local lim = grect:bottomRight()
  local overlaps = false
  for x = grect.topLeft.x, lim.x - 1 do
    for y = grect.topLeft.y, lim.y - 1 do
      local os = state.grid:lookup(x,y)
      if not (os == nil) then
        for _,o in ipairs(os) do
          print("check " .. tostring(state.player.topLeft))
          if state.player:overlaps(o) then
            overlaps = true
            goto exit
          end
        end
      end
    end
  end

  ::exit::
  if overlaps then
    state.color = {r = 255,g = 0,b = 0}
  else
    state.color = {r = 255,g = 255,b = 255}
  end
end







