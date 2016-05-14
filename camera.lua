camera = {}
local c = camera

c.width = love.graphics.getWidth()
c.height = love.graphics.getHeight()
c.x = 0
c.y = 0
c.scale = 0.001
c.mapScale = 1

function camera.update()
  c.width = love.graphics.getWidth()
  c.height = love.graphics.getHeight()
  scaleNeed = c.mapScale - c.scale
  c.scale = c.scale + scaleNeed / 24
end

function camera.draw()
  xCenter = c.x * c.scale 
  yCenter = c.x * c.scale 
  love.graphics.translate(xCenter, yCenter)
  love.graphics.scale(c.scale)
end