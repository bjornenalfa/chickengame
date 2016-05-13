Character = {}
local c = Character
c.__index = c

c.list = {}

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
  end
end

function Character.update(dt)
  for i,char in pairs(c.list) do
    if love.keyboard.isDown("a") then
      char.vx = char.vx - 100*dt
    end
    if love.keyboard.isDown("d") then
      char.vx = char.vx + 100*dt
    end
    if char:solid() then
      char.vy = 0
    else
      char.vy = char.vy + 200*dt
    end
    char.x = char.x + char.vx * dt
    char.y = char.y + char.vy * dt
  end
end

function Character.draw()
  love.graphics.setColor(255,255,255)
  for i,character in pairs(c.list) do
    love.graphics.setColor(255,0,0)
    love.graphics.circle("fill",character.x, character.y, character.r)
    --love.graphics.draw(image,character.x,character.y)
  end
end