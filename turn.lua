require("input")
turn = {}
local t = turn

t.playerOrder = {}
t.currentPlayerIndex = 0
t.currentPlayer = nil
t.currentCharacter = nil

t.aiming = false
t.aimAngle = 0
t.aimPower = 100

t.turnNumber = 0

t.turnTime = 60
t.turnTimer = 0
t.timerActive = false

t.ending = false
t.playerinput = false

t.wind = 0

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
      print("oh it is game over, well not anymore!")
      Character.new(600, 50, 20, player1, image.hen, image.hen_leg)
      --return Game.endGame()
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
  t.playerinput = true
  t.wind = math.random(-150,150)
end

function turn.fire()
  --image, locationX, locationY, length, width, speed, angle, damage, owner, duration
  pr = projectile.new(image.bazooka_missile, char.x + math.cos(t.aimAngle)*25, char.y + math.sin(t.aimAngle)*25, 10, 30, t.aimPower, t.aimAngle, 50, t.currentPlayer, 200, 50)
  t.playerinput = false
  t.aiming = false
  camera.trackEntity(pr)
end

function turn.gamepadaxis(joystick, axis)
  if not t.playerinput then return end
  if not t.currentPlayer.joystick == joystick then return end
  --print(joystick)
  if t.currentCharacter then
    char = t.currentCharacter
    x, y = joystick:getAxes()
    if t.aiming then
      t.aimAngle = math.atan2(y, x)
    end
  end
end

debugFlag = false
t.aimToggleCoolDownLength = 0.5
t.aimToggleCoolDownRemaining = 0
function turn.handleInput(dt)
  if hasInput(END_TURN) then
    t.endTurn()
    return
  end
  
  -- If we're aiming, check for aiming-related input
  if t.aiming then
    -- Axes aren't handled by hasInput(), so are handled manually here
    local joystick = t.currentPlayer.joystick
    if joystick then
      y2 = joystick:getGamepadAxis("triggerright") - joystick:getGamepadAxis("triggerleft")
      t.aimPower = math.min(math.max(100, t.aimPower + y2*400*dt), 800)
    end
    -- Now for the aiming mode hasInput() checks.
    if hasInput(CHARACTER_AIM_LEFT) then
      t.aimAngle = t.aimAngle - 2*dt
    end
    if hasInput(CHARACTER_AIM_RIGHT) then
      t.aimAngle = t.aimAngle + 2*dt
    end
    if hasInput(CHARACTER_AIM_STRENGTH_UP) then
       t.aimPower = math.min(math.max(100, t.aimPower + 400*dt), 800)
    end
    if hasInput(CHARACTER_AIM_STRENGTH_DOWN) then
       t.aimPower = math.min(math.max(100, t.aimPower - 400*dt), 800)
    end
  else
    -- Not aiming.
    -- First, axes.
    if love.joystick.getJoystickCount() > 0 then
      joystick = love.joystick.getJoysticks()[1]
      x1, y1 = joystick:getAxes()
      if math.abs(x1) > 0.2 then
        t.currentCharacter.mx = t.currentCharacter.mx + x1
      end
    end
    -- Next, hasInput() checks
    if hasInput(CHARACTER_MOVE_LEFT) then
      t.currentCharacter:move(-1)
    end
    if hasInput(CHARACTER_MOVE_RIGHT) then
      t.currentCharacter:move(1)
    end
    if hasInput(CHARACTER_JUMP) then
      t.currentCharacter:jump()
    end
    if hasInput(ACTION_PLACE_MINE) then
      Mine.new(t.currentCharacter.x, t.currentCharacter.y)
    end
  end
  
  if t.aimToggleCoolDownRemaining <= 0 then
  -- Aiming status and firing.
    if (not turn.aiming) and hasInput(CHARACTER_START_AIM) then
      turn.aiming = true
      t.aimToggleCoolDownRemaining = t.aimToggleCoolDownLength
    elseif turn.aiming then
      if hasInput(CHARACTER_STOP_AIM) then
        turn.aiming = false
        t.aimToggleCoolDownRemaining = t.aimToggleCoolDownLength
      elseif hasInput(CHARACTER_FIRE) then
        turn.fire()
      end
    end
  else
    t.aimToggleCoolDownRemaining = t.aimToggleCoolDownRemaining - dt
  end
end

function turn.update(dt)
  if t.ending then
    static = true
    for i,char in pairs(Object.list) do
      if math.abs(char.vx) > 1 or math.abs(char.vy) > 1 then
        static = false
        camera.trackEntity(char)
      end
    end
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
  if t.playerinput and t.currentCharacter then
    t.handleInput(dt)
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
      
      pangle = 0.15
      love.graphics.setColor(HSV((800-t.aimPower)/8,255,255))
      love.graphics.polygon("fill", char.x + math.cos(t.aimAngle-pangle)*20, char.y + math.sin(t.aimAngle-pangle)*20, char.x + math.cos(t.aimAngle-pangle)*(30+5*(t.aimPower/100)), char.y + math.sin(t.aimAngle-pangle)*(30+5*(t.aimPower/100)), char.x + math.cos(t.aimAngle+pangle)*(30+5*(t.aimPower/100)), char.y + math.sin(t.aimAngle+pangle)*(30+5*(t.aimPower/100)), char.x + math.cos(t.aimAngle+pangle)*20, char.y + math.sin(t.aimAngle+pangle)*20)
      love.graphics.draw(image.uzi, char.x, char.y, t.aimAngle, 1, 1, image.uzi:getWidth()/2, image.uzi:getHeight()/2)
    end
  end
end

function turn.uidraw()
  love.graphics.setColor(0,0,0)
  love.graphics.setFont(font.base)
  love.graphics.print(math.ceil(t.turnTimer), 0, 0)
  love.graphics.setFont(font.normal)
  
  bottomy = love.graphics.getHeight()
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("line",5,bottomy-25,60,20)
  love.graphics.setColor(180,180,180)
  love.graphics.rectangle("fill",5,bottomy-25,60,20)
  love.graphics.setColor(HSV(150-math.abs(t.wind),255,255))
  love.graphics.rectangle("fill",35,bottomy-23,t.wind*(30/150),16)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("fill",35,bottomy-23,1,16)
  love.graphics.print("wind",7,bottomy-21)
end
