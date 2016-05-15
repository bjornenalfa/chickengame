require("input")
camera = {}
local i = camera

i.width = love.graphics.getWidth()
i.height = love.graphics.getHeight()
i.posX = 0
i.posY = 0
i.dispX = 0
i.dispY = 0
i.scale = 1
i.mapScale = 1



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


function camera.update(dt)
  i.width = love.graphics.getWidth()
  i.height = love.graphics.getHeight()
  scaleNeed = i.mapScale - i.scale
  i.scale = i.scale + scaleNeed / 24
  
  local cw,ch = love.graphics:getDimensions()
  
  if hasInput(CAMERA_RESET) then
    i.currentlyFollowing = true
    if i.activeEntity and i.activeEntity.x and i.activeEntity.y then
      -- Valid entity to follow. Set camera position based on that.
      -- 
      i.posX = (i.activeEntity.x - (cw/2 + (i.activeEntity.r or 0)))
      i.posY = (i.activeEntity.y - (ch/2 + (i.activeEntity.r or 0)))
    end
  else
    if hasInput(CAMERA_MOVE_DOWN) then
      i.currentlyFollowing = false
      i.posY = i.posY + (i.cameraSpeed * dt)
    elseif hasInput(CAMERA_MOVE_UP) then
      i.currentlyFollowing = false
      i.posY = i.posY - (i.cameraSpeed * dt)
    end
    if hasInput(CAMERA_MOVE_LEFT) then
      i.currentlyFollowing = false
      i.posX = i.posX - (i.cameraSpeed * dt)
    elseif hasInput(CAMERA_MOVE_RIGHT) then
      i.currentlyFollowing = false
      i.posX = i.posX + (i.cameraSpeed * dt)
    else -- No manual camera movement
      if i.activeEntity and i.activeEntity.x and i.activeEntity.y and i.currentlyFollowing then
        -- We have a valid entity which we are tracking.
        -- Breaks on large maps such as 03.
        i.posX = (i.activeEntity.x - (cw/2 + (i.activeEntity.r or 0)))
        i.posY = (i.activeEntity.y - (ch/2 + (i.activeEntity.r or 0)))
      end
    end
  end
  
  -- Boundary checking - the camera should show nothing outside the map.
  -- TODO: Appears to break
  local minY = 0
  local maxY = Map.height - ch
  local minX = 0
  local maxX = Map.width - cw
  
  if i.posY < minY then
    i.posY = minY
  elseif i.posY > maxY then
    i.posY = maxY
  end
  if i.posX < minX then
    i.posX = minX
  elseif i.posX > maxX then
    i.posX = maxX
  end

end

function camera.trackEntity(target)
  i.activeEntity = target
  i.currentlyFollowing = true
end

function camera.draw()
  i.dispX = i.dispX + (i.posX - i.dispX) * 0.1
  i.dispY = i.dispY + (i.posY - i.dispY) * 0.1
  local xCenter = i.dispX * i.scale 
  local yCenter = i.dispY * i.scale 
  love.graphics.translate(-xCenter, -yCenter)
  love.graphics.scale(i.scale)
end

function camera.drawOOB()
  if i.currentlyFollowing and i.activeEntity then
    local x = math.min(math.max(0,i.activeEntity.x),Map.width)
    local y = math.min(math.max(0,i.activeEntity.y),Map.height)
    if i.activeEntity.x ~= x or i.activeEntity.y ~= y then
      love.graphics.setColor(255,255,255)
      love.graphics.draw(image.arrow, x, y, math.atan2(i.activeEntity.y-y, i.activeEntity.x-x), 2, 2, image.arrow:getWidth()/2, image.arrow:getHeight()/2)
      distance = math.sqrt((i.activeEntity.x-x)*(i.activeEntity.x-x)+(i.activeEntity.y-y)*(i.activeEntity.y-y))
      love.graphics.setColor(255,0,0)
      love.graphics.print(distance, x, y)
      --love.graphics.circle("fill", x, y, 10)
    end
  end
end