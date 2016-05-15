Grenade = {}
local g = Grenade
setmetatable(Grenade, Object)
g.__index = Grenade

function Grenade.new(x, y, power, angle)
  new = Object.new(x, y, 7, image.grenade, 1)
  new.timer = 8
  new.vx = math.cos(angle) * power
  new.vy = math.sin(angle) * power
  new.active = true
  setmetatable(new, Grenade)
  return new
end

function Grenade:die()
  Game.explode(self.x, self.y, 80, 400, 50)
end

function Grenade:explode()
  --self.dead = true
end

function Grenade:update(dt)
  self.timer = self.timer - dt
  if self.timer < 0 then
    self.dead = true
    --sound.play("grenade_arm")
  else
    if math.abs(self.vx) < 1 and math.abs(self.vy) < 1 then
      self.dead = true
    end
  end
end

function Grenade:draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.image:getWidth()/2, self.image:getHeight()/2)
end