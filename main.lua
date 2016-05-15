require "camera"
require "font"
require "floattext"
require "image"
require "map"
require "sound"
require "explosions"
require "Character"
require "Player"
require "turn"
require "Game"
require "projectile"
require "ui"
require "Object"
require "Mine"
require "Barrel"

player1 = Player.new("chicken",1)
player2 = Player.new("zombie",2)
turn.setPlayerOrder(player1, player2)

main = {}

function love.load()
  math.randomseed(os.time())
  camera.listen(main)
  Map.loadMap("map04")
  --Character.new(600, 50, 20, player1, image.hen, image.hen_leg)
  --Character.new(500, 50, 25, player2, image.zombie, image.zombie_leg)
  --Character.new(400, 50, 25, player2, image.zombie2, image.zombie_leg)
  for i = 1, 5 do
    x = 0
    y = 0
    for j = 1, 200 do
      x = math.random(0, Map.width)
      y = math.random(0, Map.height)
      if Map.isSolid(x,y) then
        break
      end
    end
    while y > 0 and Map.isSolid(x,y) do
      y = y - 1
    end
    Character.new(x, y-25, 20, player1, image.hen, image.hen_leg)
  end
  for i = 1, 5 do
    x = 0
    y = 0
    for j = 1, 200 do
      x = math.random(0, Map.width)
      y = math.random(0, Map.height)
      if Map.isSolid(x,y) then
        break
      end
    end
    while y > 0 and Map.isSolid(x,y) do
      y = y - 1
    end
    Character.new(x, y-30, 25, player2, image.zombie, image.zombie_leg)
  end
  for i = 1, 10 do
    x = 0
    y = 0
    for j = 1, 200 do
      x = math.random(0, Map.width)
      y = math.random(0, Map.height)
      if Map.isSolid(x,y) then
        break
      end
    end
    while y > 0 and Map.isSolid(x,y) do
      y = y - 1
    end
    place = true
    for i,char in pairs(Character.list) do
      if (char.x-x)*(char.x-x) + (char.y-y)*(char.y-y) <= 65*65 then
        place = false
        break
      end
    end
    if place then
      thing = math.random(1,2)
      if thing == 1 then
        Mine.new(x,y,true)
      elseif thing == 2 then
        Barrel.new(x,y)
      end
    end
  end
  turn.nextTurn()
  sound.play("theme")
end

function main.onClick(x, y, button)
  Game.explode(x, y, 30, 300, 50)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

time = 0
function love.update(dt)
  dt = math.min(0.04, dt)
  time = time + dt
  camera.update(dt)
  projectile.update(dt)
  explosions.update(dt)
  Character.update(dt)
  Object.updateAll(dt)
  floattext.update(dt)
  turn.update(dt)
end

function love.draw()
  camera.draw()
  Map.drawBackground()
  explosions.drawShake()
  Map.draw()
  Character.draw()
  Object.drawAll()
  projectile.draw()
  turn.draw()
  floattext.draw()
  explosions.draw()
  camera.drawOOB()
  
  ui.draw()
  --love.graphics.print(love.joystick.getJoystickCount(),0,50)
  
  --[[love.graphics.setColor(0,0,0)
  if Map.isSolid(love.mouse.getPosition()) then
    love.graphics.print("solid",0,0)
  else
    love.graphics.print("air",0,0)
  end]]
end
