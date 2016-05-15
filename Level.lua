Level = {}
local l = Level

function level.reset()
  Character.list = {}
  Object.list = {}
  projectile.projectiles = {}
  explosions.explosions = {}
  floattext.list = {}
  love.audio.stop()
  turn.endTurn()
end

function Level.load(number)
  mapname = "map0"..number
  Map.loadMap(mapname)
  if number == 4 then
    for i = 1, 5 do
      l.placeChicken()
    end
    for i = 1, 5 do
      l.placeZombie()
    end
    for i = 1, 10 do
      l.placeMine()
    end
    for i = 1, 10 do
      l.placeBarrel()
    end
  end
  
  turn.setPlayerOrder(player1, player2)
  turn.nextTurn()
  sound.play("theme")
end

function l.placeChicken()
  l.place(function(x,y)
    Character.new(x, y-30, 20, player1, image.hen, image.hen_leg)
  end)
end

function l.placeZombie()
  l.place(function(x,y)
    Character.new(x, y-30, 25, player2, image.zombie, image.zombie_leg)
  end)
end

function l.placeMine()
  l.place(function(x,y)
    Mine.new(x,y,true)
  end, true)
end

function l.placeBarrel()
  l.place(function(x,y)
    Barrel.new(x, y)
  end, true)
end

function l.place(func, avoid)
  x = 0
  y = 0
  for j = 1, 200 do
    x = math.random(0, Map.width)
    y = math.random(0, Map.height)
    if Map.isSolid(x,y) then
      break
    end
  end
  while y > 0 and Map.isSolid(x,y) do
    y = y - 1
  end
  if avoid then
    place = true
    for i,char in pairs(Character.list) do
      if (char.x-x)*(char.x-x) + (char.y-y)*(char.y-y) <= 65*65 then
        place = false
        break
      end
    end
    if place then
      func(x,y)
    end
  else
    func(x,y)
  end
end