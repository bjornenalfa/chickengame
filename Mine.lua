Mine = {}
local m = Mine
setmetatable(Mine, Object)
m.__index = Mine

function Mine.new(x, y, activated)
  new = Object.new(x, y, 10, image.egg, 1)
  new.timer = 3
  new.activated = activated or false
  new.triggered = false
  new.range = 50
  setmetatable(new, Mine)
  return new
end

function Mine:die()
  Game.explode(self.x, self.y, 80, 500, 60)
end

function Mine:explode()
  --self.dead = true
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
          self.active = true
          sound.play("mine_alarm")
          self.timer = 3
        end
      end
    end
  else
    self.timer = self.timer - dt
    if self.timer < 0 then
      self.activated = true
      sound.play("mine_activate")
    end
  end
end

function Mine:draw()
  if not self.activated then
    love.graphics.setColor(HSV(90,self.timer*(255/3),255))
  elseif self.triggered then
    love.graphics.setColor(HSV(0,255-math.abs(((self.timer*1000)%510)-255),255))
  else
    love.graphics.setColor(255,255,255)
  end
  love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.image:getWidth()/2, self.image:getHeight()/2)
end