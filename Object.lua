Object = {}
local o = Object
o.__index = o

o.list = {}

o.maxHeightStep = 5

function Object.new(x, y, r, owner, image)
  new = {x=x,
        y=y,
        r=r,
        dx=0,
        vx=0,
        vy=0,
        owner=owner,
        image=image,
        dead = false,
  }
  setmetatable(new, Object)
  table.insert(o.list, new)
  return new
end

function Object:solid(side)
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

function Object:slide(dx)
  x = self.x
  y = self.y + self.r
  if Map.isSolid(x+dx, y-1) then
    for dy = 2, o.maxHeightStep do
      if not Map.isSolid(x+dx,y-dy) then
        self.x = x + dx
        self.y = self.y - dy + 1
        self.vx = self.vx - dx * dy*3
        self.vy = self.vy - dy * 8
        return
      end
    end
    self.vx = 0
  else
    self.x = self.x + dx
  end
end

function Object:die()
  --Game.explode(self.x, self.y, 20, 200, 30)
end

function Object.explosion(x, y, r, power)
  for i,obj in pairs(o.list) do
    distance = math.sqrt((obj.x-x)*(obj.x-x)+(obj.y-y)*(obj.y-y))
    if distance <= r + obj.r then
      depth = math.max(0,distance - obj.r)
      strength = (r-depth)/r
      impulse = power*strength
      direction = math.atan2(obj.y-y, obj.x-x)
      obj.vx = obj.vx + math.cos(direction) * impulse
      if math.sin(direction) * impulse > 0 then
        obj.vy = obj.vy - math.sin(direction) * impulse * 0.2
      else
        obj.vy = obj.vy + math.sin(direction) * impulse
      end
    end
  end
end

function Object.update(dt)
  dead = {}
  for i,obj in pairs(o.list) do
    if obj.vy < 0 and obj:solid("above") then
      obj.vy = 1
      while obj:solid("above") do
          obj.y = obj.y + 1
      end
      obj.y = obj.y - 1
    end
    if obj:solid("under") then
      if obj.vy > 400 then
        obj:damage((obj.vy-400)*0.5)
      end
      if obj.vy > 0 then
        while obj:solid("under") do
          obj.y = obj.y - 1
        end
        obj.y = obj.y + 1
        obj.vy = 0
      end
      obj.vx = obj.vx * 0.95
    else
      obj.vy = obj.vy + Game.gravity*dt
      obj.vx = obj.vx * 0.99
    end
    obj.dx = obj.dx + obj.vx * dt
    while math.abs(obj.dx) > 1 do
      obj:slide(obj.dx/math.abs(obj.dx))
      obj.dx = obj.dx - obj.dx/math.abs(obj.dx)
    end
    obj.y = obj.y + obj.vy * dt
    obj.vy = obj.vy * 0.995
    if obj.y > Map.height then
      obj.dead = true
    end
    if obj.dead then
      table.insert(dead,i)
    end
  end
  for i = #dead, 1, -1 do
    obj = o.list[dead[i]]
    table.remove(o.list, dead[i])
    obj:die()
  end
end

function Object.draw()
  love.graphics.setColor(255,255,255)
  for i,obj in pairs(o.list) do
    love.graphics.setColor(255,255,255)
    if obj.direction == "right" then
      love.graphics.draw(obj.image, obj.x, obj.y, 0, 1, 1, obj.image:getWidth()/2, obj.image:getHeight()/2)
    else
      love.graphics.draw(obj.image, obj.x, obj.y, 0, -1, 1, obj.image:getWidth()/2, obj.image:getHeight()/2)
    end
    love.graphics.setColor(255,0,0,100)
    --love.graphics.circle("fill",obj.x, obj.y, obj.r)
  end
end