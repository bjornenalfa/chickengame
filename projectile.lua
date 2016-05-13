projectile = {}
local p = projectile

p.projectiles = {}

p.maxHeightAllowed = Map.height
p.maxHeightAllowed = 2 * p.maxHeightAllowed
p.minHeightAllowed = 0

p.furthestLeftAllowed = -500
p.furthestRightAllowed = (Map.width * 2) + 500

p.maxDuration = -1

function projectile.new(image, mass, locationX, locationY, length, width, speed, angle, damage, owner, duration)
  table.insert(p.projectiles, {
      img = image,
      m = mass,
      x = locationX,
      y = locationY,
      l = length,
      w = width,
      vx = speed * math.cos(angle),
      vy = speed * math.sin(angle),
      d = damage,
      duration = 0,
      owner = owner,
      maxDuration = duration
  })
end

function projectile.update(dt)
  collisions = {}
  projectileRemovals = {}
  expired = {}
  for projectileIndex, pr in pairs(p.projectiles) do
    pr.duration = pr.duration + dt
    if pr.maxDuration > 0 and pr.duration > pr.maxDuration then
      table.insert(expired, projectileIndex)
    elseif pr.x < pr.furthestLeftAllowed or pr.x > pr.furthestRightAllowed or pr.y < minHeightAllowed or pr.y > maxHeightAllowed then
      table.insert(expired, projectileIndex)
    else
      -- First, update position
      ax = 0 -- If we want projectiles that slow down, we can add that later.
      ay = -10 -- Accelerate down at 10px/whateverTimeUnitWeUse by default. Probably not a reasonable number.
      pr.vx = pr.vx + (dt * ax) -- Update velocities
      pr.vy = pr.vy + (dt * ay) 
      pr.x = pr.x + (pr.vx * dt) -- Update positions
      pr.y = pr.y + (pr.vy * dt)
      
      -- Now, terrain collisions
      collided = false
      -- Not too accurate, but it will do
      if Map.isSolid(pr.x, pr.y) then collided = true end
      
      -- Next, if that didn't happen, character collisions
      if not collided then
        for _, char in pairs(Character.list) do
          local sqDist = (char.x - pr.x)^2 + (char.y - pr.y)^2
          if sqDist <= char.r then
            collided = true
            break
          end
        end
      end
      
      -- TOmaybeDO projectile-projectile collision
      
      if collided then
        table.insert(collisions, projectileIndex)
      end
  end
  for i = #projectileRemovals, 1, -1 do
    explosions.new(p.projectiles[projectileRemovals[i]].x, p.projectiles[projectileRemovals[i]].y, 0.2, p.projectiles[projectileRemovals[i]].w, true)
    table.remove(p.projectiles, projectileRemovals[i])
  end
  for i = #collisions, 1, -1 do
    explosions.new(p.projectiles[collisions[i]].x, p.projectiles[collisions[i]].y, 0.2, p.projectiles[collisions[i]].w, true)
    table.remove(p.projectiles, collisions[i])
  end
  for i = #expired, 1, -1 do
    explosions.new(p.projectiles[expired[i]].x, p.projectiles[expired[i]].y, 0.2, p.projectiles[expired[i]].w, true)
    table.remove(p.projectiles, expired[i])
  end
end

end
function projectile.draw()
  for _, pr in pairs(p.projectiles) do
    love.graphics.setColor(pr.owner.color)
    --love.graphics.line(pr.ox, pr.oy, pr.x, pr.y)
    love.graphics.draw(pr.img, pr.x, pr.y, (math.atan2(pr.vy, pr.vx)), pr.w/pr.img:getWidth(), pr.l/pr.img:getHeight(), 0, 0)
  end
end