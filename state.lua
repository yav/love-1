require "lib.Rectangle"
require "lib.Vec2D"

--- @class State
--- @field player Rectangle
--- @field other  Rectangle
state = {}

function state:init()
  self.player = Rectangle:new(Vec2D:new(0,0), Vec2D:new(50,60))
  self.other  = Rectangle:new(Vec2D:new(40,20), Vec2D:new(32,32))
end



