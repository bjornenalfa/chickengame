require "camera"
require "image"
require "map"
require "sound"
require "explosions"
require "Character"

function love.load()
  Map.loadMap("map01")
  Character.new(500, 50, 10, "dev", image.zombie)
  Character.new(500, 50, 10, "dev", image.hen)
end

function love.mousepressed(x, y, button)
  x = x - camera.x
  y = y - camera.y
  Map.circle(x, y, 30)
  explosions.new(x, y, 0.3, 30, true)
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
end

function love.draw()
  camera.draw()
  Map.drawBackground()
  explosions.draw()
  Map.draw()
  Character.draw()
  
  love.graphics.setColor(0,0,0)
  if Map.isSolid(love.mouse.getPosition()) then
    love.graphics.print("solid",0,0)
  else
    love.graphics.print("air",0,0)
  end
end
