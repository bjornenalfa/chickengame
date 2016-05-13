camera = {}
local c = camera

c.width = love.window.getWidth()
c.height = love.window.getHeight()
c.x = 0
c.y = 0
c.scale = 0.001
c.mapScale = 0.7

function camera.update()
  c.width = love.window.getWidth()
  c.height = love.window.getHeight()
  scaleNeed = c.mapScale - c.scale
  c.scale = c.scale + scaleNeed / 24
end

function camera.draw()
  xCenter = c.x * c.scale + c.width / 2 
  yCenter = c.x * c.scale + c.height / 2
  love.graphics.translate(xCenter, yCenter)
  love.graphics.scale(c.scale)
end