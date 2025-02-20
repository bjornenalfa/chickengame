Player = {}
local p = Player
p.__index = p

p.list = {}

function Player.new(name,joystick,weapons)
  if love.joystick.getJoystickCount() > 0 then
    joysticks = love.joystick.getJoysticks()
    joystick = joysticks[math.min(#joysticks,joystick)]
  else
    joystick = nil
  end
  new = {
    name=name,
    joystick=joystick,
    color = {255,255,255},
    weaponIndex = 1,
    allowedWeapons = weapons
  }
  setmetatable(new, Player)
  p.list[name] = new
  return new
end

function Player:getWeapon()
  return self.allowedWeapons[self.weaponIndex]
end
