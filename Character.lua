Character = {}
local c = Character
c.__index = c

c.list = {}

c.maxHeightStep = 5

function Character.new(x, y, r, owner, image)
  new = {x=x,
        y=y,
        r=r,
        vx=0,
        vy=0,
        owner=owner,
        image=image
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

function Character.update(dt)
  for i,char in pairs(c.list) do
    if love.keyboard.isDown("a") then
      char:move(-1)
    end
    if love.keyboard.isDown("d") then
      char:move(1)
    end
    if char:solid("under") then
      char.vy = 0
    else
      char.vy = char.vy + 200*dt
    end
    --if char:solid("above") then
    --  char.vy = 1
    --end
    --char.x = char.x + char.vx * dt
    char.y = char.y + char.vy * dt
  end
end

function Character.draw()
  love.graphics.setColor(255,255,255)
  for i,char in pairs(c.list) do
    love.graphics.setColor(255,255,255)
    love.graphics.draw(char.image, char.x, char.y, 0, 1, 1, char.image:getWidth()/2, char.image:getHeight()/2)
    love.graphics.setColor(255,0,0,100)
    love.graphics.circle("fill",char.x, char.y, char.r)
  end
end