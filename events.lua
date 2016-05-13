events = {}
local e = events

--[[ 1 - Drunkmode
  
  ]]

e.active = {}
e.stop = {}
e.amount = 10
e.recommended = {10, 20, 25, 10, 10, 15, 15, 50, 20, 15}

cars = false

function events.init()
  for i = 1, e.amount do
    e.active[i] = false
  end
end

function events.startEvent(i, time)
  if e.active[i] then
    return
  end
  e.active[i] = true
  table.insert(e.stop, {time=time, event=i})
  if i == 1 then
    --[[e.showText("Space sunglasses")
    drunkMode = true
    sound.battle1:stop()
    sound.battle2:stop()
    sound.battle3:stop()
    sound.play(sound.sandstorm)]]
  elseif i == 2 then
    e.showText("Black holes")
    for _,v in pairs(planet.suns) do
      v.oldr = v.r
      v.r = 1
      --v.scale = v.r * 2 / v.image:getWidth()
      v.oldImage = v.image
      v.image = image.blackhole_mini
    end
  elseif i == 3 then
    e.showText("Speed up")
    timeMultiplier = timeMultiplier * 2
  elseif i == 4 then
    e.showText("Speed down")
    timeMultiplier = timeMultiplier * 0.5
  elseif i == 5 then
    e.showText("Rapid fire")
    player.cooldown = player.cooldown / 10
    player.damage = player.damage / 10
  elseif i == 6 then
    e.showText("Avoid traffic")
    cars = true
    maxAsteroids = maxAsteroids * 1.5
  elseif i == 7 then
    e.showText("More asteroids")
    maxAsteroids = maxAsteroids * 3
  elseif i == 8 then
    e.showText("More moons")
    angle = math.rad(math.random(0,359))
    player1.planet:addMoon(planet.new(1e6,    100,  10,     angle,    1.5,   0,   100,    {math.random(0,255), math.random(0,255), math.random(0,255)},  image["planet_"..math.random(1,5)]))
    player2.planet:addMoon(planet.new(1e6,    100,  10,     angle,    1.5,   0,   100,    {math.random(0,255), math.random(0,255), math.random(0,255)},  image["planet_"..math.random(1,5)]))
  elseif i == 9 then
    e.showText("Double trouble")
    doubleShot = true
  elseif i == 10 then
    e.showText("Double damage")
    player.cooldown = player.cooldown * 1.5
    player.damage = player.damage * 2
  end
end

function events.stopEvent(i)
  e.active[i] = false
  if i == 1 then
    --[[drunkMode = false
    sound.sandstorm:stop()
    music = sound["battle"..math.random(1,3)]
    music:setLooping(true)
    sound.play(music)]]
  elseif i == 2 then
    for _,v in pairs(planet.suns) do
      v.r = v.oldr
      v.scale = v.r * 2 / v.image:getWidth()
      v.image = v.oldImage
    end
  elseif i == 3 then
    timeMultiplier = timeMultiplier / 2
  elseif i == 4 then
    timeMultiplier = timeMultiplier / 0.5
  elseif i == 5 then
    player.cooldown = player.cooldown * 10
    player.damage = player.damage * 10
  elseif i == 6 then
    cars = false
    maxAsteroids = maxAsteroids / 1.5
  elseif i == 7 then
    maxAsteroids = maxAsteroids / 3
  elseif i == 8 then
    
  elseif i == 9 then
    doubleShot = false
  elseif i == 10 then
    player.cooldown = player.cooldown / 1.5
    player.damage = player.damage / 2
  end
end

function events.stopAll()
  e.stop = {}
  for i = 1, e.amount do
    if e.active[i] then
      e.stopEvent(i)
    end
  end
end

function events.showText(text, text2)
  e.showtext = true
  e.texttime = 3
  e.text = text
  e.secondtext = text2
end

timeWithoutEvent = 0
function events.update(dt)
  if e.texttime <= 0 then
    if math.random(1,(1/dt)*30) == 1 or timeWithoutEvent >= 40 then
      possible = {}
      for i = 1, e.amount do
        if not e.active[i] then
          table.insert(possible, i)
        end
      end
      if #possible > 0 then
        chosen = possible[math.random(1,#possible)]
        events.startEvent(chosen, e.recommended[chosen])
        timeWithoutEvent = 0
      end
    else
      timeWithoutEvent = timeWithoutEvent + dt / timeMultiplier
    end
  end
  if e.showtext then
    e.texttime = e.texttime - dt
    if e.texttime <= 0 then
      e.showtext = false
    end
  end
  toStop = {}
  for _,v in pairs(e.stop) do
    v.time = v.time - dt
    if v.time <= 0 then
      table.insert(toStop, _)
    end
  end
  for i = #toStop, 1, -1 do
    events.stopEvent(e.stop[toStop[i]].event)
    table.remove(e.stop, toStop[i])
  end
end

e.showtext = false
e.text = ""
e.secondtext = ""
e.texttime = 0

function events.draw()
  if e.showtext then
    menu.drawOutlinedText(e.text, 0, font.big, 3, {255,255,255,178}, {0,0,0,20})
    --menu.drawOutlinedText(e.secondtext, -70, font.h1, 2, {255,255,255,128}, {0,0,0,20})
  end
end