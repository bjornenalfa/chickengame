Map = {}
local m = Map

m.currentImage = nil
m.currentBackground = nil
m.canvas = nil
m.canvasData = nil

function Map.loadMap(name)
  m.currentImage = getImage(name)
  m.currentBackground = getImage(name.."bg")
  m.canvas = love.graphics.newCanvas(m.currentImage:getWidth(), m.currentImage:getHeight())
  m.canvas:renderTo(function()
    love.graphics.setColor(255,255,255)
    love.graphics.draw(m.currentImage)
  end)
  m.updateData()
end

function Map.updateData()
  m.canvasData = m.canvas:newImageData()
end

function Map.isSolid(x, y)
  r,g,b,a = m.canvasData:getPixel(x, y)
  return a == 255
end

function Map.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(m.currentBackground)
  love.graphics.draw(m.canvas)
end

