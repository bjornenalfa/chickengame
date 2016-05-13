explosions = {}
local e = explosions

e.explosions = {}

function explosions.new(x, y, time, radius, playSound)
  if playSound then
    sound.play(sound["explosion"..math.random(1,3)])
  end
  newEx = {
    x = x,
    y = y,
    r = radius,
    time = time,
    t = 0,
    frame = 1
  }
  table.insert(e.explosions, newEx)
  return newEx
end

frames = 6
function explosions.update(dt)
  toRemove = {}
  for _,v in pairs(e.explosions) do
    v.t = v.t + dt
    if v.t >= v.time then
      table.insert(toRemove,_)
    else
      v.frame = math.floor((v.t/v.time)*frames) +1
    end
  end
  for i = #toRemove, 1, -1 do
    table.remove(e.explosions, toRemove[i])
  end
end

function explosions.draw()
  love.graphics.setColor(255,255,255)
  for _,v in pairs(e.explosions) do
    love.graphics.translate(math.random(-5,5), math.random(-5,5))
    img = image["planetexplosion"..v.frame]
    w = img:getWidth()
    h = img:getHeight()
    love.graphics.draw(img, v.x, v.y, 0, v.r*2/w, v.r*2/h, w/2, h/2)
  end
end
