Character = {}
local c = Character
c.__index = c

c.list = {}

c.maxHeightStep = 5

function Character.new(x, y, r, owner, image)
  new = {x=x,
        y=y,
        r=r,
        dx=0,
        vx=0,
        vy=0,
        owner=owner,
        image=image,
        hp=100,
        maxhp=100,
        lastTurn = 0
  }
  setmetatable(new, Character)
  table.insert(c.list, new)
  return new
end

function Character:solid(side)
  if side == "under" then
    return Map.isSolid(self.x, self.y + self.r)
  elseif side == "above" then
    return Map.isSolid(self.x, self.y - self.r)
  elseif side == "left" then
    return Map.isSolid(self.x - self.r, self.y)
  elseif side == "right" then
    return Map.isSolid(self.x + self.r, self.y)
  end
end

function Character:move(dx)
  if not self:solid("under") then
    return self:slide(dx)
  end
  x = self.x
  y = self.y + self.r
  local solid = Map.isSolid
  if solid(x+dx, y-1) then
    for dy = 2, c.maxHeightStep do
      if not solid(x+dx,y-dy) then
        self.x = x + dx
        self.y = self.y - dy + 1
        break
      end
    end
  else
    for dy = 0, c.maxHeightStep do
      if not solid(x+dx,y+dy) then
        --self.x = x + dx
        self.y = self.y - dy + 1
        break
      end
    end
    self.x = self.x + dx
  end
end

function Character:slide(dx)
  x = self.x
  y = self.y + self.r
  local solid = Map.isSolid
  if solid(x+dx, y-1) then
    for dy = 2, c.maxHeightStep do
      if not solid(x+dx,y-dy) then
        self.x = x + dx
        self.y = self.y - dy + 1
        self.vx = self.vx - dx * dy*3
        self.vy = self.vy - dy * 8
        return
      end
    end
    self.vx = 0
  else
    --[[for dy = 0, c.maxHeightStep do
      if not solid(x+dx,y+dy) then
        --self.x = x + dx
        self.y = self.y - dy + 1
        break
      end
    end]]
    self.x = self.x + dx
  end
end

function Character:jump()
  if self:solid("under") then
    self.vy = -250
  end
end

function Character:damage(damage)
  damage = math.floor(damage+0.5)
  if damage > 0 then
    self.hp = self.hp - damage
    floattext.new("-"..damage, self.x, self.y, {255,255,255}, font.base)
  end
end

function Character.explosion(x, y, r, power, damage)
  for i,char in pairs(c.list) do
    distance = math.sqrt((char.x-x)*(char.x-x)+(char.y-y)*(char.y-y))
    if distance <= r + char.r then
      depth = math.max(0,distance - r)
      strength = (char.r-depth)/char.r
      char:damage(damage*strength)
      impulse = power*strength
      direction = math.atan2(char.y-y, char.x-x)
      char.vx = char.vx + math.cos(direction) * impulse
      if math.sin(direction) * impulse > 0 then
        char.vy = char.vy - math.sin(direction) * impulse * 0.2
      else
        char.vy = char.vy + math.sin(direction) * impulse
      end
    end
  end
end

function Character.update(dt)
  for i,char in pairs(c.list) do
    if love.keyboard.isDown("a") then
      char:move(-1)
    end
    if love.keyboard.isDown("d") then
      char:move(1)
    end
    if love.keyboard.isDown("w") then
      char:jump()
    end
    if char.vy < 0 and char:solid("above") then
      char.vy = 1
      while char:solid("above") do
          char.y = char.y + 1
      end
      char.y = char.y - 1
    end
    if char:solid("under") then
      if char.vy > 300 then
        char:damage((char.vy-300)*0.5)
      end
      if char.vy > 0 then
        while char:solid("under") do
          char.y = char.y - 1
        end
        char.y = char.y + 1
        char.vy = 0
      end
      char.vx = char.vx * 0.95
    else
      char.vy = char.vy + 300*dt
      char.vx = char.vx * 0.99
    end
    char.dx = char.dx + char.vx * dt
    while math.abs(char.dx) > 1 do
      char:slide(char.dx/math.abs(char.dx))
      char.dx = char.dx - char.dx/math.abs(char.dx)
    end
    char.y = char.y + char.vy * dt
    char.vy = char.vy * 0.995
  end
end

function Character.draw()
  love.graphics.setColor(255,255,255)
  for i,char in pairs(c.list) do
    love.graphics.setColor(255,255,255)
    love.graphics.draw(char.image, char.x, char.y, 0, 1, 1, char.image:getWidth()/2, char.image:getHeight()/2)
    love.graphics.setColor(255,0,0,100)
    love.graphics.circle("fill",char.x, char.y, char.r)
    
    love.graphics.rectangle("fill",char.x-20,char.y-40,40,10)
    love.graphics.rectangle("fill",char.x-20,char.y-40,40*(char.hp/char.maxhp),10)
  end
end