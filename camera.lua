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

i.activeEntity = nil
i.currentlyFollowing = false

i.cameraSpeed = 2000

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
    i.currentlyFollowing = true
    if i.activeEntity and i.activeEntity.x and i.activeEntity.y then
      -- Valid entity to follow. Set camera position based on that.
      -- TODO - make it work.
      i.posX = -(i.activeEntity.x + (cw - Map.width)/2)
      i.posY = ((ch - Map.height)/2  - i.activeEntity.y)
    else
      print("Nothing to follow")
    end
  elseif love.keyboard.isDown(camera.CAMERA_MOVE_DOWN) then
    i.currentlyFollowing = false
    i.posY = i.posY - (i.cameraSpeed * dt)
    print("Down")
    if i.posY > Map.height then
      i.posY = Map.height
    end
  elseif love.keyboard.isDown(camera.CAMERA_MOVE_UP) then
    i.currentlyFollowing = false
    i.posY = i.posY + (i.cameraSpeed * dt)
    print("Up")
    if i.posY < 0 then
      i.posY = 0
    end
  elseif love.keyboard.isDown(camera.CAMERA_MOVE_LEFT) then
    i.currentlyFollowing = false
    i.posX = i.posX + (i.cameraSpeed * dt)
    print("Left")
    if i.posX < cw - Map.width then
      print("Too far left (was "..i.posX..")")
      i.posX = cw - Map.width
    end
  elseif love.keyboard.isDown(camera.CAMERA_MOVE_RIGHT) then
    i.currentlyFollowing = false
    i.posX = i.posX - (i.cameraSpeed * dt)
    print("Right")
    if i.posX > 0 then
      i.posX = 0
      print("Too far right")
    end
  else -- No manual camera movement
    if i.activeEntity and i.activeEntity.x and i.activeEntity.y and i.currentlyFollowing then
      -- We have a valid entity which we are tracking.
      -- TODO: Track it.
      i.posX = -(i.activeEntity.x + (cw - Map.width)/2)
      i.posY = ((ch - Map.height)/2  - i.activeEntity.y)
    else
      print("Not tracking")
    end
  end
end

function camera.trackEntity(target)
  i.activeEntity = target
  i.currentlyFollowing = true
end

function camera.draw()
  local xCenter = i.posX * i.scale 
  local yCenter = i.posY * i.scale 
  love.graphics.translate(xCenter, yCenter)
  love.graphics.scale(i.scale)
end