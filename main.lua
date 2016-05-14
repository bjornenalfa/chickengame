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

player1 = Player.new("chicken")
player2 = Player.new("zombie")

function love.load()
  Map.loadMap("map01")
  Character.new(600, 50, 20, player1, image.hen)
  Character.new(500, 50, 20, player2, image.zombie)
end

function love.mousepressed(x, y, button)
  Map.circle(x, y, 30)
  explosions.new(x, y, 0.3, 30, true)
  Character.explosion(x, y, 30, 300, 50)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

time = 0
function love.update(dt)
  time = time + dt
  camera.update(dt)
  explosions.update(dt)
  Character.update(dt)
  floattext.update(dt)
end

function love.draw()
  camera.draw()
  Map.drawBackground()
  explosions.drawShake()
  Map.draw()
  Character.draw()
  floattext.draw()
  explosions.draw()
  
  love.graphics.setColor(0,0,0)
  if Map.isSolid(love.mouse.getPosition()) then
    love.graphics.print("solid",0,0)
  else
    love.graphics.print("air",0,0)
  end
end
