camera = {}
local i = camera

i.width = love.graphics.getWidth()
i.height = love.graphics.getHeight()
i.posX = 0
i.posY = 0
i.scale = 1
i.mapScale = 1

camera.CAMERA_MOVE_DOWN = "down"
camera.CAMERA_MOVE_UP = "up"
camera.CAMERA_MOVE_LEFT = "left"
camera.CAMERA_MOVE_RIGHT = "right"
camera.CAMERA_RESET = "space"

i.cameraSpeed = 200

i.mouseListeners = {}

function love.mousepressed(x, y, button)
  print(x, y)
  local logicalX = (x + i.posX)/i.mapScale
  local logicalY = (y + i.posY)/i.mapScale
  print(logicalX, logicalY)
  for _, ml in pairs(camera.mouseListeners) do
    ml.onClick(logicalX, logicalY, button)
  end
end

function camera.listen(l)
  if l ~= nil then
    table.insert(camera.mouseListeners, l)
  else
    print("nil listener")
  end
end

function camera.update(dt)
  i.width = love.graphics.getWidth()
  i.height = love.graphics.getHeight()
  scaleNeed = i.mapScale - i.scale
  i.scale = i.scale + scaleNeed / 24
  
  local ch,cw = Map.canvas:getDimensions()
  
  if love.keyboard.isDown(camera.CAMERA_RESET) then
    -- TODO: Reset camera position.
  end
  if love.keyboard.isDown(camera.CAMERA_MOVE_DOWN) then
    i.posY = i.posY - i.cameraSpeed
    print("Down")
    if i.posY > Map.height then
      i.posY = Map.height
    end
  elseif love.keyboard.isDown(camera.CAMERA_MOVE_UP) then
    i.posY = i.posY + i.cameraSpeed
    print("Up")
    if i.posY < 0 then
      i.posY = 0
    end
  end
  if love.keyboard.isDown(camera.CAMERA_MOVE_LEFT) then
    i.posX = i.posX + i.cameraSpeed
    print("Left")
    if i.posX < cw - Map.width then
      print("Too far left (was "..i.posX..")")
      i.posX = cw - Map.width
    end
  elseif love.keyboard.isDown(camera.CAMERA_MOVE_RIGHT) then
    i.posX = i.posX - i.cameraSpeed
    print("Right")
    if i.posX > 0 then
      i.posX = 0
      print("Too far right")
    end
  end
end

function camera.draw()
  local xCenter = i.posX * i.scale 
  local yCenter = i.posY * i.scale 
  love.graphics.translate(xCenter, yCenter)
  love.graphics.scale(i.scale)
end