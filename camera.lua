camera = {}
local i = camera

i.width = love.graphics.getWidth()
i.height = love.graphics.getHeight()
i.posX = 0
i.posY = 0
i.scale = 1
i.mapScale = 1

camera.CAMERA_MOVE_DOWN = {keyboard={"down"}, gamepad={"dpdown"}}
camera.CAMERA_MOVE_UP = {keyboard={"up"}, gamepad={"dpup"}}
camera.CAMERA_MOVE_LEFT = {keyboard={"left"}, gamepad={"dpleft"}}
camera.CAMERA_MOVE_RIGHT = {keyboard={"right"}, gamepad={"dpright"}}
camera.CAMERA_RESET = {keyboard={"h"}, gamepad={"y"}}

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
  end
end

function hasInput(inputs, gamepads)
  gamepads = gamepads or {}
  inputs = inputs or {}
  inputs["keyboard"] = inputs["keyboard"] or {}
  inputs["gamepad"] = inputs["gamepad"] or {}
  for _,kbinput in pairs(inputs["keyboard"]) do
    if (type(kbinput)=="string") and love.keyboard.isDown(kbinput) then return true end
  end
  for _,gpinput in pairs(inputs["gamepad"]) do
    for _,gamepad in pairs(gamepads) do
      if (type(gpinput)=="string") and gamepad:isGamepadDown(gpinput) then return true end
    end
  end
  return false
end

function camera.update(dt)
  i.width = love.graphics.getWidth()
  i.height = love.graphics.getHeight()
  scaleNeed = i.mapScale - i.scale
  i.scale = i.scale + scaleNeed / 24
  
  local cw,ch = love.graphics:getDimensions()
  
  local joysticks = love.joystick.getJoysticks()
  
  if hasInput(camera.CAMERA_RESET, joysticks) then
    i.currentlyFollowing = true
    if i.activeEntity and i.activeEntity.x and i.activeEntity.y then
      -- Valid entity to follow. Set camera position based on that.
      -- TODO - make it work.
      i.posX = -(i.activeEntity.x + (cw - Map.width)/2)
      i.posY = ((ch - Map.height)/2  - i.activeEntity.y)
    end
  elseif hasInput(camera.CAMERA_MOVE_DOWN, joysticks) then
    i.currentlyFollowing = false
    i.posY = i.posY - (i.cameraSpeed * dt)
  elseif hasInput(camera.CAMERA_MOVE_UP, joysticks) then
    i.currentlyFollowing = false
    i.posY = i.posY + (i.cameraSpeed * dt)
  elseif hasInput(camera.CAMERA_MOVE_LEFT, joysticks) then
    i.currentlyFollowing = false
    i.posX = i.posX + (i.cameraSpeed * dt)
  elseif hasInput(camera.CAMERA_MOVE_RIGHT, joysticks) then
    i.currentlyFollowing = false
    i.posX = i.posX - (i.cameraSpeed * dt)
  else -- No manual camera movement
    if i.activeEntity and i.activeEntity.x and i.activeEntity.y and i.currentlyFollowing then
      -- We have a valid entity which we are tracking.
      -- TODO: Track it.
      i.posX = -(i.activeEntity.x + (cw - Map.width)/2)
      i.posY = -(i.activeEntity.y + (ch - Map.height)/2)
    end
  end
  
  -- Boundary checking - the camera should show nothing outside the map.
  -- TODO: Make it actually work when moving camera down or right.
  local minY = ch - Map.height
  local maxY = 0
  local minX = cw - Map.width
  local maxX = 0
  
  if i.posY < minY then
    i.posY = minY
    print("Y too low!")
  elseif i.posY > maxY then
    i.posY = maxY
    print("Y too high!")
  end
  if i.posX < minX then
    i.posX = minX
    print("X too low!")
  elseif i.posX > maxX then
    i.posX = maxX
    print("X too high!")
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