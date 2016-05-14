Mine = {}
local m = Mine
m.__index = Object

function Mine.new(x, y)
  new = Object.new(x, y, 10, image.egg, 1)
  setmetatable(new, Mine)
  return new
end

function Mine:update(dt)
  
end