camera = {}
local c = camera

c.width = love.graphics.getWidth()
c.height = love.graphics.getHeight()
c.x = 0
c.y = 0
c.scale = 1
c.mapScale = 1

c.CAMERA_MOVE_DOWN = "down"
c.CAMERA_MOVE_UP = "up"
c.CAMERA_MOVE_LEFT = "left"
c.CAMERA_MOVE_RIGHT = "right"

c.cameraSpeed = 200

function camera.update()
  c.width = love.graphics.getWidth()
  c.height = love.graphics.getHeight()
  scaleNeed = c.mapScale - c.scale
  c.scale = c.scale + scaleNeed / 24
  
  if love.keyboard.isDown(c.CAMERA_MOVE_DOWN) then
    c.y = c.y - c.cameraSpeed
    print("Down")
    if c.y < 0 then
      c.y = 0
    end
  elseif love.keyboard.isDown(c.CAMERA_MOVE_UP) then
    c.y = c.y + c.cameraSpeed
    print("Up")
    if c.y > Map.height then
      c.y = Map.height
    end
  end
  if love.keyboard.isDown(c.CAMERA_MOVE_LEFT) then
    c.x = c.x + c.cameraSpeed
    print("Left")
    if c.x > Map.width then
      c.x = Map.width
    end
  elseif love.keyboard.isDown(c.CAMERA_MOVE_RIGHT) then
    c.x = c.x - c.cameraSpeed
    print("Right")
    if c.x < 0 then c.x = 0 end
  end
end

function camera.draw()
  xCenter = c.x * c.scale 
  yCenter = c.y * c.scale 
  love.graphics.translate(xCenter, yCenter)
  love.graphics.scale(c.scale)
end