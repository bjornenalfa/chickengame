projectile = {}
local p = projectile

p.projectiles = {}

p.minHeightAllowed = 0

p.furthestLeftAllowed = -500
p.furthestRightAllowed = (Map.width * 2) + 500

p.maxDuration = -1

function projectile.new(image, locationX, locationY, length, width, speed, angle, damage, owner, power, radius)
  new = {
      img = image,
      x = locationX,
      y = locationY,
      l = length,
      w = width,
      vx = speed * math.cos(angle),
      vy = speed * math.sin(angle),
      d = damage,
      duration = 0,
      owner = owner,
      power = power,
      radius = radius,
      remove = false
  }
  table.insert(p.projectiles, new)
  return new
end

function projectile.update(dt)
  removeList = {}
  for projectileIndex, pr in pairs(p.projectiles) do
    pr.duration = pr.duration + dt
    if pr.x < -500 or pr.x > (Map.width * 2) + 500 or pr.y < -1000 or pr.y > Map.height*2 then
      pr.remove = true
    else
      -- First, update position
      ax = turn.wind -- If we want projectiles that slow down, we can add that later.
      ay = Game.gravity -- Accelerate down at 10px/whateverTimeUnitWeUse by default. Probably not a reasonable number.
      pr.vx = pr.vx + (dt * ax) -- Update velocities
      pr.vy = pr.vy + (dt * ay) 
      pr.x = pr.x + (pr.vx * dt) -- Update positions
      pr.y = pr.y + (pr.vy * dt)
      
      -- Now, terrain collisions
      collided = false
      -- Not too accurate, but it will do
      if Map.isSolid(pr.x, pr.y) then 
        collided = true
      else
        -- Next, if that didn't happen, character collisions
        for _, char in pairs(Character.list) do
          local sqDist = (char.x - pr.x)^2 + (char.y - pr.y)^2
          if sqDist <= char.r*char.r then
            collided = true
            break
          end
        end
      end
      -- TOmaybeDO projectile-projectile collision
      
      if collided then
        pr.remove = true
      end
    end
    if pr.remove then
      table.insert(removeList, projectileIndex)
    end
  end
  for i = #removeList, 1, -1 do
    pr = p.projectiles[removeList[i]]
    Game.explode(pr.x, pr.y, pr.radius, pr.power, pr.d)
    if not turn.playerinput then
      turn.endTurn()
    end
    table.remove(p.projectiles, removeList[i])
  end
end

function projectile.draw()
  for _, pr in pairs(p.projectiles) do
    love.graphics.setColor(pr.owner.color)
    --love.graphics.line(pr.ox, pr.oy, pr.x, pr.y)
    love.graphics.draw(pr.img, pr.x, pr.y, math.atan2(pr.vy, pr.vx), 1, 1, pr.img:getWidth()/2, pr.img:getHeight()/2)
  end
end