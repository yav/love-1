require "lib.Map2D"

CollisionMap = {}
local meta = { __index = CollisionMap }

function CollisionMap:new(size)
  local obj = {}
  obj.size = size -- of each square
  obj.data = Map2D:new()
  return setmetatable(obj, meta)
end

--- Add an object to the map.
--- @param r Rectangle
--- @param obj any
function CollisionMap:addObj(r,obj)
  local grect = r:toGrid(self.size)
  local lim   = grect:bottomRight()
  for x = grect.topLeft.x, lim.x - 1 do
    for y = grect.topLeft.y, lim.y - 1 do
      local os = self.data:lookupWithDefault(x,y,{})
      os[obj] = r
    end
  end
end

function CollisionMap:removeObj(r,obj)
  local grect = r:toGrid(self.size)
  local lim   = grect:bottomRight()
  for x = grect.topLeft.x, lim.x - 1 do
    for y = grect.topLeft.y, lim.y - 1 do
      local os = self.data:lookup(x,y)
      if not (os == nil) then os[obj] = nil end
    end
  end
end

--- [const] Check if the givn rectangle collides with anything in the map.
--- @param r Rectangle
--- @return boolean
function CollisionMap:hasCollisions(r)
    local known = {}
    local grect = r:toGrid(self.size)
    local lim   = grect:bottomRight()
    for x = grect.topLeft.x, lim.x - 1 do
      for y = grect.topLeft.y, lim.y - 1 do
        local os = self.data:lookup(x,y)
        if not (os == nil) then
          for o,r1 in pairs(os) do
            if known[o] == nil then
              if r:overlaps(r1) then return true end
              known[o] = true -- any non-nil value works
            end
          end
        end
      end
    end
    return false
  end


--- [const] Find objects in the map colliding wth the given rectangle.
--- @param r Rectangle
--- @return table
function CollisionMap:findCollisions(r)
  local objs  = {}
  local known = {}
  local grect = r:toGrid(self.size)
  local lim   = grect:bottomRight()
  for x = grect.topLeft.x, lim.x - 1 do
    for y = grect.topLeft.y, lim.y - 1 do
      local os = self.data:lookup(x,y)
      if not (os == nil) then
        for o,r1 in pairs(os) do
          if known[o] == nil then
            if r:overlaps(r1) then
              objs[#objs + 1] = o
            end
            known[o] = true -- any non-nil value works
          end
        end
      end
    end
  end
  return objs
end