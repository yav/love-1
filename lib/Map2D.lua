--- @class Map2D
Map2D = {}
local meta = { __index = Map2D }

--- Create a new empty table
--- @return Map2D
function Map2D:new()
  local obj = {}
  return setmetatable(obj, meta)
end

--- [const] Get the object at the given index.
--- @param x any First key
--- @param y any Second key
--- @return any _ The element stored at the given index or `nil`
function Map2D:lookup(x,y)
  local d1 = self[x]
  if d1 == nil then return nil end
  return d1[y]
end




--- Get the object at the given index. If the index does not exist,
--- then we create it, and store the given dflt in the map.
--- @param x any
--- @param y any
--- @param dflt any
--- @return any _ The thing stored at the given index.
function Map2D:lookupWithDefault(x,y,dflt)
  local d1 = self[x]
  if d1 == nil then
    d1 = {}
    self[x] = d1
  end
  local d2 = d1[y]
  if d2 == nil then
    d1[y] = dflt
    return dflt
  else
    return d2
  end
end
