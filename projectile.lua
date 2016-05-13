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
      ox = 0,
      oy = 0, -- What are these?
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
      --[[ TODO: Collisions with entities and terrain.
      collided = false
      ax = 0
      ay = 0
      for _, pl in pairs(planet.planets) do
        sqdis = (pl.x - pr.x)*(pl.x - pr.x) + (pl.y - pr.y)*(pl.y - pr.y)
        angle = math.atan2(pl.y - pr.y, pl.x - pr.x)
        g = (pl.m) / sqdis
        ax = ax + math.cos(angle) * g
        ay = ay + math.sin(angle) * g
      end
      pr.vx = pr.vx + ax * dt 
      pr.vy = pr.vy + ay * dt
      pr.x = pr.x + (pr.vx * dt)
      pr.y = pr.y + (pr.vy * dt)
      
      for _, pl in pairs(planet.planets) do
        if (pl.x - pr.x)*(pl.x - pr.x) + (pl.y - pr.y)*(pl.y - pr.y) < pl.r*pl.r then
          if not pl.isSun then
            pl.hp = pl.hp - pr.d
            belongsToPlayer = false
            for _, plr in pairs(player.players) do
              if plr.planet == pl then
                belongsToPlayer = true
                break
              end
            end
            if belongsToPlayer then
              pr.owner.score = pr.owner.score + 100 * pr.duration
            end
          end
          table.insert(collisions, projectileIndex)
          collided = true
          break
        end
      end
      
      for i, other in pairs(p.projectiles) do
        if (pr.x - other.x) * (pr.x - other.x) + (pr.y - other.y) * (pr.y - other.y) < 10*10 and pr ~= other then
          if not collided then
            table.insert(projectileRemovals, projectileIndex)
          end
          --table.insert(collisions, i)
          break
        end
      end
    end
    ]]--
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

function projectile.draw()
  for _, pr in pairs(p.projectiles) do
    love.graphics.setColor(pr.owner.color)
    --love.graphics.line(pr.ox, pr.oy, pr.x, pr.y)
    love.graphics.draw(pr.img, pr.x, pr.y, (math.atan2(pr.vy, pr.vx)), pr.w/pr.img:getWidth(), pr.l/pr.img:getHeight(), 0, 0)
  end
end