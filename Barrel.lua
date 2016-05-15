Barrel = {}
local b = Barrel
setmetatable(Barrel, Object)
b.__index = Barrel

function Barrel.new(x, y)
  new = Object.new(x, y, 16, image.barrel, 1)
  setmetatable(new, Barrel)
  return new
end

function Barrel:die()
  Game.explode(self.x, self.y, 75, 500, 40)
end

function Barrel:explode()
  self.dead = true
end