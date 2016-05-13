require "image"
require "map"

function love.load()
  Map.loadMap("map01")
end

time = 0
function love.update(dt)
  time = time + dt
end

function love.mousepressed(x, y, button)
  Map.circle(x, y, 30)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  Map.draw()
  love.graphics.setColor(0,0,0)
  if Map.isSolid(love.mouse.getPosition()) then
    love.graphics.print("solid",0,0)
  else
    love.graphics.print("air",0,0)
  end
end
