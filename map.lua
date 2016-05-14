Map = {}
local m = Map

m.currentImage = nil
m.currentBackground = nil
m.canvas = nil
m.canvas2 = nil
m.canvasData = nil
m.width = 0
m.height = 0

local function updateData() -- this must be called after any modification to the map
  m.canvasData = m.canvas:newImageData()
end

function Map.loadMap(name)
  m.currentImage = getImage(name)
  m.currentBackground = getImage(name.."bg")
  m.layer2 = getImage(name.."layer2")
  m.canvas = love.graphics.newCanvas(m.currentImage:getWidth(), m.currentImage:getHeight())
  m.canvas:renderTo(function()
    love.graphics.setColor(255,255,255)
    love.graphics.draw(m.currentImage)
  end)
  m.canvas2 = love.graphics.newCanvas(m.layer2:getWidth(), m.layer2:getHeight())
  m.canvas2:renderTo(function()
    love.graphics.setColor(255,255,255)
    love.graphics.draw(m.layer2)
  end)
  m.width = m.currentImage:getWidth()
  m.height = m.currentImage:getHeight()
  updateData()
end

function Map.circle(x, y, r)
  love.graphics.origin()
  
  love.graphics.setCanvas(m.canvas)
  love.graphics.setBlendMode("replace")
  love.graphics.setColor(0,0,0,0)
  love.graphics.circle("fill",x,y,r)
  
  love.graphics.setCanvas(m.canvas2)
  love.graphics.setColor(0,0,0,0)
  love.graphics.circle("fill",x,y,math.max(0,r-2))
  love.graphics.setBlendMode("alpha")
  
  love.graphics.setCanvas()
  updateData()
end

function Map.isSolid(x, y)
  r,g,b,a = m.canvasData:getPixel(math.min(math.max(0,math.floor(x)),m.width-1), math.min(math.max(0,math.floor(y)),m.height-1))
  return a == 255
end

--[[function Map.isEmpty(x, y)
  r,g,b,a = m.canvasData:getPixel(math.floor(x), math.floor(y))
  return a ~= 255
end]]

function Map.drawBackground()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(m.currentBackground)
end

function Map.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(m.canvas2)
  love.graphics.draw(m.canvas)
end

