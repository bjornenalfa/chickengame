Player = {}
local p = Player
p.__index = p

p.list = {}

function Player.new(name)
  new = {
    name=name,
    color = {255,255,255}
  }
  setmetatable(new, Player)
  p.list[name] = new
  return new
end
