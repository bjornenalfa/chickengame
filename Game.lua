Game = {} -- random stuff used by everything goes in here

Game.gravity = 300

function Game.explode(x, y, r, power, damage)
  Map.circle(x, y, r)
  explosions.new(x, y, 0.3, r, true)
  Character.explosion(x, y, r, power, damage)
  Object.explosion(x, y, r, power)
end

function Game.gameOver()
  Level.reset()
  Level.load(math.random(1,4))
  --return error("Game over!")
end

function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h, s, v = h/256*6, s/255, v/255
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255
end

function Game.stuffMoving()
  static = true
  thing = nil
  if #explosions.explosions > 0 then
    static = false
    thing = explosions.explosions[1]
  end
  for i,obj in pairs(Object.list) do
    if math.abs(obj.vx) > 1 or math.abs(obj.vy) > 1 or obj.active then
      static = false
      thing = obj
    end
  end
  for i,char in pairs(Character.list) do
    if math.abs(char.vx) > 1 or math.abs(char.vy) > 1 then
      static = false
      thing = char
    end
  end
  if #projectile.projectiles > 0 then
    static = false
    thing = projectile.projectiles[1]
  end
  return not static, thing
end