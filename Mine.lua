Mine = {}
local m = Mine
setmetatable(Mine, Object)
m.__index = Mine

function Mine.new(x, y)
  new = Object.new(x, y, 10, image.egg, 1)
  new.timer = 3
  new.activated = false
  new.triggered = false
  new.range = 50
  setmetatable(new, Mine)
  return new
end

function Mine:die()
  Game.explode(self.x, self.y, 80, 400, 50)
end

function Mine:explode()
  self.dead = true
end

function Mine:update(dt)
  if self.activated then
    if self.triggered then
      self.timer = self.timer - dt
      if self.timer < 0 then
        self.dead = true
      end
    else
      for i,char in pairs(Character.list) do
        if (char.x-self.x)*(char.x-self.x) + (char.y-self.y)*(char.y-self.y) <= self.range*self.range then
          self.triggered = true
          sound.play("missile_shoot")
          self.timer = 3
        end
      end
    end
  else
    self.timer = self.timer - dt
    if self.timer < 0 then
      self.activated = true
      sound.play("laser_shoot")
    end
  end
end