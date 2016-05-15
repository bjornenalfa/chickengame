Map = {}
local m = Map

m.currentImage = nil
m.currentBackground = nil
m.canvas = nil
m.canvas2 = nil
m.canvas3 = nil
m.canvas4 = nil
m.canvasData = nil
m.width = 0
m.height = 0

local counter = 0
local function updateData() -- this must be called after any modification to the map
  counter = counter + 1
  m.canvasData = m.canvas:newImageData()
  if counter > 20 then
    collectgarbage()
    counter = 0
  end
end

function Map.loadMap(name)
  m.currentImage = getImage(name)
  m.currentBackground = getImage(name.."bg")
  m.canvas = love.graphics.newCanvas(m.currentImage:getWidth(), m.currentImage:getHeight())
  m.canvas:renderTo(function()
    love.graphics.setColor(255,255,255)
    love.graphics.draw(m.currentImage)
  end)
  for layer = 2,4 do
    m["layer"..layer] = getImage(name.."layer"..layer)
    m["canvas"..layer] = love.graphics.newCanvas(m["layer"..layer]:getWidth(), m["layer"..layer]:getHeight())
    m["canvas"..layer]:renderTo(function()
      love.graphics.setColor(255,255,255)
      love.graphics.draw(m["layer"..layer])
    end)
  end
  m.width = m.currentImage:getWidth()
  m.height = m.currentImage:getHeight()
  updateData()
end

function Map.circle(x, y, r)
  love.graphics.origin()
  love.graphics.setBlendMode("replace")
  
  love.graphics.setCanvas(m.canvas)
  love.graphics.setColor(0,0,0,0)
  love.graphics.circle("fill",x,y,r)
  
  love.graphics.setCanvas(m.canvas2)
  love.graphics.setColor(0,0,0,0)
  love.graphics.circle("fill",x,y,math.max(0,r-2))
  
  love.graphics.setCanvas(m.canvas3)
  love.graphics.setColor(0,0,0,0)
  love.graphics.circle("fill",x,y,math.max(0,r-8))
  
  love.graphics.setCanvas(m.canvas4)
  love.graphics.setColor(0,0,0,0)
  love.graphics.circle("fill",x,y,math.max(0,r-40))
  
  love.graphics.setBlendMode("alpha")
  love.graphics.setCanvas()
  updateData()
end

function Map.isSolid(x, y)
  local r,g,b,a = m.canvasData:getPixel(math.min(math.max(0,math.floor(x)),m.width-1), math.min(math.max(0,math.floor(y)),m.height-1))
  return a == 255
end

--[[function Map.isEmpty(x, y)
  r,g,b,a = m.canvasData:getPixel(math.floor(x), math.floor(y))
  return a ~= 255
end]]

function Map.drawBackground()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(m.currentBackground,0,0,0,1,1, -(camera.dispX - (m.currentBackground:getWidth() - love.graphics.getWidth()) * (camera.dispX/Map.width)), -(camera.dispY - (m.currentBackground:getHeight() - love.graphics.getHeight()) * (camera.dispY/Map.height)))
end

function Map.draw()
  love.graphics.setColor(255,255,255)
  for layer = 4,2,-1 do
    love.graphics.draw(m["canvas"..layer])
  end
  love.graphics.draw(m.canvas)
  
  love.graphics.setColor(255,0,0)
  love.graphics.print("Camera: "..camera.posX..", "..camera.posY, -camera.posX, -camera.posY)
  love.graphics.print("MAp dimensions: "..Map.width..", "..Map.height, -camera.posX, -camera.posY + 10)
  local w,h = love.graphics:getDimensions()
  love.graphics.print("Window dimensions: "..w..", "..h, -camera.posX, -camera.posY + 20)
end

