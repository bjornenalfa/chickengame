Player = {}
local p = Player
p.__index = p

p.list = {}

function Player.new(name)
  new = {
    name=name
  }
  setmetatable(new, Player)
  p.list[name] = new
  return new
end
