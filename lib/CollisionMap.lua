require "lib.Map2D"

CollisionMap = {}
local meta = { __index = CollisionMap }

function CollisionMap:new(size)
  local obj = {}
  obj.size = size
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
      os[#os + 1] = { rect = r, obj = obj }
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
          for _,o in ipairs(os) do
            local candidate = o.obj
            if known[candidate] == nil then
              if r:overlaps(o.rect) then
                return true
              end
              known[candidate] = true -- any non-nil value works
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
        for _,o in ipairs(os) do
          local candidate = o.obj
          if known[candidate] == nil then
            if r:overlaps(o.rect) then
              objs[#objs + 1] = candidate
            end
            known[candidate] = true -- any non-nil value works
          end
        end
      end
    end
  end
  return objs
end