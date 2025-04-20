--- @class Map2D
Map2D = {}
local meta = { __index = Map2D }

--- Create a new empty table
--- @return Map2D
function Map2D:new()
  local obj = {}
  return setmetatable(obj, meta)
end

--- Get the object at the given index. If the index does not exist,
--- we create, with its value being an empty table.
--- @param v Vec2D coordinate to lookup
--- @return table _ the things stored at the given index
function Map2D:lookup(v)
  local col = self[v.x]
  if col == nil then
    col = {}
    self[v.x] = col
  end
  local row = col[v.y]
  if row == nil then
    row = {}
    col[v.y] = row
  end
  return row
end

--- Make a new table with fresh indexes.  The stored eleemnts are shared.
function Map2D:clone()
  local t = Map2D:new()
  for c,col in ipairs(self) do
    local co = {}
    for r,row in ipairs(col) do
      local ro = {}
      for i,el in ipairs(row) do
        ro[i] = el
      end
      co[r] = ro
    end
    t[c] = co
  end
  return t
end
