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

player1 = Player.new("chicken")
player2 = Player.new("zombie")
turn.setPlayerOrder(player1, player2)

function love.load()
  Map.loadMap("map02")
  Character.new(600, 50, 20, player1, image.hen, image.hen_leg)
  Character.new(500, 50, 20, player2, image.zombie, image.zombie_leg)
  turn.nextTurn()
end

function love.mousepressed(x, y, button)
  Game.explode(x, y, 30, 300, 50)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  turn.keypressed(key)
end

time = 0
function love.update(dt)
  time = time + dt
  camera.update(dt)
  explosions.update(dt)
  Character.update(dt)
  floattext.update(dt)
  turn.update(dt)
end

function love.draw()
  camera.draw()
  Map.drawBackground()
  explosions.drawShake()
  Map.draw()
  Character.draw()
  turn.draw()
  floattext.draw()
  explosions.draw()
  
  --[[love.graphics.setColor(0,0,0)
  if Map.isSolid(love.mouse.getPosition()) then
    love.graphics.print("solid",0,0)
  else
    love.graphics.print("air",0,0)
  end]]
end
