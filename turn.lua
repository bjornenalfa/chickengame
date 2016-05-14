turn = {}
local t = turn

t.playerOrder = {}
t.currentPlayerIndex = 0
t.currentPlayer = nil
t.currentCharacter = nil

t.aiming = false
t.aimAngle = 0

t.turnNumber = 0

t.turnTime = 60
t.turnTimer = 0
t.timerActive = false

t.ending = false

function turn.setPlayerOrder(...)
  t.playerOrder = {...}
end

function turn.endTurn()
  t.turnTimer = 2
  t.ending = true
  --turn.nextTurn()
end

function turn.nextTurn()
  t.turnNumber = t.turnNumber + 1
  t.currentPlayerIndex = (t.currentPlayerIndex % #t.playerOrder) + 1
  t.currentPlayer = t.playerOrder[t.currentPlayerIndex]
  oldest = nil
  for i,char in pairs(Character.list) do
    if char.owner == t.currentPlayer then 
      if oldest == nil then
        oldest = char
      elseif char.lastTurn < oldest.lastTurn and not char.dead and char.hp > 0 then
        oldest = char
      end
    end
  end
  if oldest == nil then
    if #Character.list == 0 then
      print("oh it is game over")
      return Game.endGame()
    end
    print("next player has no characters left?")
    return turn.nextTurn()
  end
  oldest.lastTurn = t.turnNumber
  t.currentCharacter = oldest
  camera.trackEntity(oldest)
  t.timerActive = true
  t.turnTimer = t.turnTime
  t.aiming = false
  t.aimAngle = 0
  t.ending = false
end

function turn.fire()
  --image, locationX, locationY, length, width, speed, angle, damage, owner, duration
  pr = projectile.new(image.bazooka_missile, char.x + math.cos(t.aimAngle)*20, char.y + math.sin(t.aimAngle)*20, 10, 30, 400, t.aimAngle, 50, t.currentPlayer, 30)
  t.ending = true
  camera.trackEntity(pr)
end

function turn.gamepadpressed(joystick, button)
  if not t.ending then
    if t.currentCharacter then
      if button == "x" then
        if t.aiming then
          t.fire()
        else
          t.aiming = true
        end
      elseif button == "x" then
        t.aiming = false
      elseif button == "a" then
        if t.currentCharacter:solid("under") then
          t.currentCharacter:jump()
        end
      elseif button == "b" then
        if t.aiming then
          t.aiming = false
        end
      end
    end
  end
end

function turn.gamepadaxis(joystick, axis)
  --print(joystick)
  if t.currentCharacter then
    char = t.currentCharacter
    x, y = joystick:getAxes()
    if t.aiming then
      t.aimAngle = math.atan2(y, x)
    end
  end
end

function turn.keypressed(key)
  if t.ending then return end
  if key == "space" then
    if not t.aiming then
      t.aiming = true
    else
      t.aiming = false
    end
  elseif key == "f" then
    t.fire()
  end
end

function turn.update(dt)
  if t.ending then
    static = true
    for i,char in pairs(Character.list) do
      if math.abs(char.vx) > 1 or math.abs(char.vy) > 1 then
        static = false
        camera.trackEntity(char)
      end
    end
    if #projectile.projectiles > 0 then
      static = false
      camera.trackEntity(projectile.projectiles[1])
    end
    if not static then return end
  end
  t.turnTimer = t.turnTimer - dt
  if t.turnTimer <= 0 then
    if t.ending then
      t.nextTurn()
    else
      t.endTurn()
    end
  end
  
  if t.ending then return end
  if t.currentCharacter then
    if t.aiming then
      if love.keyboard.isDown("a") then
        t.aimAngle = t.aimAngle - 2*dt
      end
      if love.keyboard.isDown("d") then
        t.aimAngle = t.aimAngle + 2*dt
      end
    else
      if love.joystick.getJoystickCount() > 0 then
        joystick = love.joystick.getJoysticks()[1]
        if math.abs(joystick:getAxes()) > 0.1 then
          t.currentCharacter.mx = t.currentCharacter.mx + joystick:getAxes()
        end
      end
      if love.keyboard.isDown("a") then
        t.currentCharacter:move(-1)
      end
      if love.keyboard.isDown("d") then
        t.currentCharacter:move(1)
      end
      if love.keyboard.isDown("w") then
        t.currentCharacter:jump()
      end
    end
  end
end

function turn.draw()
  if t.currentCharacter then
    char = t.currentCharacter
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("line",char.x-char.r, char.y-char.r, char.r*2, char.r*2)
    if t.aiming then
      love.graphics.setColor(0,255,0)
      love.graphics.line(char.x + math.cos(t.aimAngle)*20, char.y + math.sin(t.aimAngle)*20, char.x + math.cos(t.aimAngle)*60, char.y + math.sin(t.aimAngle)*60)
    end
  end
end

function turn.uidraw()
  love.graphics.setColor(0,0,0)
  love.graphics.setFont(font.base)
  love.graphics.print(math.ceil(t.turnTimer), 0, 0)
  love.graphics.setFont(font.normal)
end
