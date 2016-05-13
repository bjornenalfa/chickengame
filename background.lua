background = {}
local b = background

b.starList = {}
b.starCanvas = love.graphics.newCanvas(2500, 1500)

function b.load()
  width = b.starCanvas:getWidth()
  height = b.starCanvas:getHeight()
  b.starCanvas:renderTo(function ()
    for i = 0, 1000 do
      img = image.star1
      if i % 2 == 0 then img = image.star2 end
      x = math.random(0, width)
      y = math.random(0, height)
      scale = math.random(10, 20) / 100
      color = {255, 255, 255, math.random(20, 170)}
      love.graphics.setColor(color)
      love.graphics.draw(img, x, y, 0, scale)
    end
  end)
end

function b.drawNormal()
  width = b.starCanvas:getWidth()
  height = b.starCanvas:getHeight()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(b.starCanvas, 0, 0)
end

function b.drawDrunk()
  love.graphics.setColor(255, 255, 255)
  b.drawFancy()
  starScale = 0.4
  imgList = {image.stars1, image.stars2, image.stars3, image.stars4}
  img = imgList[math.floor(time * 4 % 4 + 1)]
  width = img:getWidth()
  height = img:getHeight()
  for x = -10, 10 do
    for y = -10, 10 do
      dir = 1
      if x % 2 == 1 then dir = -1 end
      diff = dir * (time * 400 % height)
      red = math.floor(time * 120 % 510)
      green = math.floor(time * 300 % 510)
      blue = math.floor(time * 420 % 510)
      if red > 255 then red = 509 - red end
      if green > 255 then green = 509 - green end
      if blue > 255 then blue = 509 - blue end
      love.graphics.setColor(red, green, blue)
      love.graphics.draw(img, width * x * starScale, (height * y + diff) * starScale, 0, starScale)
    end
  end
end

function b.drawFancy()
  img = image.background2
  width = img:getWidth()
  height = img:getHeight()
  love.graphics.draw(img, - width / 2, - height / 2)
end