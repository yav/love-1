--- @class Color
--- @field r number 0--255
--- @field g number 0--255
--- @field b number 0--255
--- @field a number 0--1
Color = {}
local meta = { __index = Color }

function Color:new(r,g,b,a)
  local obj = { r = r, g = g, b = b, a = a }
  return setmetatable(obj, meta)
end

--- @return number r
--- @return number g
--- @return number b
--- @return number a
function Color:unpack()
  return self.r, self.g, self.b, self.a
end

