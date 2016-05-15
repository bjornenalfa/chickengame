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
t.weaponWait = false
t.afterWeaponMove = false

t.wind = 0
t.maxwind = 100

t.movementSpeed = 1

function turn.setPlayerOrder(...)
  t.playerOrder = {...}
end

function turn.endTurn()
  t.turnTimer = 2
  t.ending = true
  t.weaponWait = false
  t.afterWeaponMove = false
  t.playerinput = false
  --turn.nextTurn()
end

function turn.nextTurn()
  t.turnNumber = t.turnNumber + 1
  if #t.playerOrder == 0 then
    floattext.new("It is a draw?", camera.posX + love.graphics.getWidth()/2, camera.posY + love.graphics.getHeight()/2, {0,0,0}, font.h1)
    print("it is a draw!")
    Game.gameOver()
  elseif #t.playerOrder == 1 then
    floattext.new(t.playerOrder[1].name.." won!", camera.posX + love.graphics.getWidth()/2, camera.posY + love.graphics.getHeight()/2, {0,0,0}, font.h1)
    print(t.playerOrder[1].name.." won!")
    Game.gameOver()
  end
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
      print("no characters left")
      --Character.new(600, 50, 20, player1, image.hen, image.hen_leg)
      return Game.gameOver()
    end
    print("next player has no characters left")
    table.remove(t.playerOrder, t.currentPlayerIndex)
    return turn.nextTurn()
  end
  oldest.lastTurn = t.turnNumber
  t.currentCharacter = oldest
  camera.trackEntity(oldest)
  floattext.new(t.currentPlayer.name.."'s turn!", oldest.x, oldest.y, {0,0,0}, font.h1)
  t.timerActive = true
  t.turnTimer = t.turnTime
  t.aiming = false
  t.aimAngle = 0
  t.ending = false
  t.playerinput = true
  t.wind = math.random(-t.maxwind,t.maxwind)
  t.weaponWait = false
  t.aimToggleCoolDownRemaining = 0
end

function turn.fire()
  Weapon.activate(t.currentPlayer:getWeapon(), t.currentCharacter.x, t.currentCharacter.y, t.aimPower, t.aimAngle, t.currentPlayer)
  t.playerinput = false
  t.aiming = false
  t.weaponWait = true
end

debugFlag = false
t.aimToggleCoolDownLength = 0.5
t.aimToggleCoolDownRemaining = 0
function turn.handleInput(dt)
  if hasInput(END_TURN) then
    t.endTurn()
    return
  end
  
  -- Weapon switching
  t.weaponSwitchCooldownDuration = 0.2
  if (t.weaponSwitchCooldownRemaining or 0) <= 0 then
    if hasInput(NEXT_WEAPON) then
      local index = t.currentPlayer.weaponIndex
      index = index + 1
      if index > #t.currentPlayer.allowedWeapons then index = 1 end
      t.currentPlayer.weaponIndex = index
      t.weaponSwitchCooldownRemaining = t.weaponSwitchCooldownDuration
    elseif hasInput(PREV_WEAPON) then
      local index = t.currentPlayer.weaponIndex
      index = index - 1
      if index <= 0 then index = #t.currentPlayer.allowedWeapons end
      t.currentPlayer.weaponIndex = index
      t.weaponSwitchCooldownRemaining = t.weaponSwitchCooldownDuration
    end
  else
    t.weaponSwitchCooldownRemaining = t.weaponSwitchCooldownRemaining - dt
  end
  -- If we're aiming, check for aiming-related input
  if t.aiming then
    -- hasInput() doesn't handle multiple axes at once, so stick aiming is done here.
    local joystick = t.currentPlayer.joystick
    if joystick then
      local x, y = joystick:getAxes()
      local aimDeadzone = 0.04
      if x*x + y*y >= aimDeadzone then
        t.aimAngle = math.atan2(y, x)
      end
    end
    -- Now for the aiming mode hasInput() checks.
    if hasInput(CHARACTER_AIM_LEFT) then
      t.aimAngle = t.aimAngle - 1*dt
    end
    if hasInput(CHARACTER_AIM_RIGHT) then
      t.aimAngle = t.aimAngle + 1*dt
    end
    if hasInput(CHARACTER_AIM_STRENGTH_UP) then
       t.aimPower = math.min(math.max(100, t.aimPower + 400*dt), 800)
    end
    if hasInput(CHARACTER_AIM_STRENGTH_DOWN) then
       t.aimPower = math.min(math.max(100, t.aimPower - 400*dt), 800)
    end
  else
    -- Not aiming.
    if hasInput(CHARACTER_MOVE_LEFT) then
      check, val = hasInput(CHARACTER_MOVE_LEFT)
      t.currentCharacter.mx = t.currentCharacter.mx - math.abs(val) * t.movementSpeed
      --t.currentCharacter:move(-1)
    end
    if hasInput(CHARACTER_MOVE_RIGHT) then
      check, val = hasInput(CHARACTER_MOVE_RIGHT)
      t.currentCharacter.mx = t.currentCharacter.mx + math.abs(val) * t.movementSpeed
    end
    if hasInput(CHARACTER_JUMP) then
      t.currentCharacter:jump()
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
        t.aimToggleCoolDownRemaining = t.aimToggleCoolDownLength
        --print("fire in the hole")
      end
    end
  else
    t.aimToggleCoolDownRemaining = t.aimToggleCoolDownRemaining - dt
  end
end

function turn.update(dt)
  if t.weaponWait then
    if Weapon.done(dt) then
      t.weaponWait = false
      t.afterWeaponMove = true
      t.playerinput = true
      t.turnTimer = 5
      t.aimToggleCoolDownRemaining = 5
      camera.trackEntity(t.currentCharacter)
    else
      return
    end
  elseif t.afterWeaponMove then
    moving, thing = Game.stuffMoving()
    if moving and thing ~= t.currentCharacter and not thing.active then
      camera.trackEntity(thing)
      return
    end
    camera.trackEntity(t.currentCharacter)
    t.turnTimer = t.turnTimer - dt
    if t.turnTimer < 0 then
      t.endTurn()
    else
      t.handleInput(dt)
    end
    return
  elseif t.ending then
    moving, thing = Game.stuffMoving()
    if moving then
      camera.trackEntity(thing)
      return
    end
  end
  t.turnTimer = t.turnTimer - dt
  if t.turnTimer <= 0 then
    if t.ending then
      t.nextTurn()
    else
      t.endTurn()
    end
  elseif t.playerinput and t.currentCharacter then
    t.handleInput(dt)
  end
end

function turn.draw()
  if t.currentCharacter then
    char = t.currentCharacter
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("line",char.x-char.r, char.y-char.r, char.r*2, char.r*2)
    if t.aiming then
      if math.cos(t.aimAngle) < 0 then
        t.currentCharacter.direction = "left"
      else
        t.currentCharacter.direction = "right"
      end
      love.graphics.setColor(0,255,0)
      love.graphics.line(char.x + math.cos(t.aimAngle)*20, char.y + math.sin(t.aimAngle)*20, char.x + math.cos(t.aimAngle)*60, char.y + math.sin(t.aimAngle)*60)
      
      pangle = 0.15
      love.graphics.setColor(HSV((800-t.aimPower)/8,255,255))
      love.graphics.polygon("fill", char.x + math.cos(t.aimAngle-pangle)*20, char.y + math.sin(t.aimAngle-pangle)*20, char.x + math.cos(t.aimAngle-pangle)*(30+5*(t.aimPower/100)), char.y + math.sin(t.aimAngle-pangle)*(30+5*(t.aimPower/100)), char.x + math.cos(t.aimAngle+pangle)*(30+5*(t.aimPower/100)), char.y + math.sin(t.aimAngle+pangle)*(30+5*(t.aimPower/100)), char.x + math.cos(t.aimAngle+pangle)*20, char.y + math.sin(t.aimAngle+pangle)*20)
      Weapon.draw(t.currentPlayer.allowedWeapons[t.currentPlayer.weaponIndex], char.x, char.y, t.aimAngle, t.aimPower)
      --love.graphics.setColor(255,255,255)
      --love.graphics.draw(image.bazooka, char.x, char.y, t.aimAngle, 1, 1, image.bazooka:getWidth()/2, image.bazooka:getHeight()/2)
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
  
  -- debug
  --love.graphics.print(currentWeapon, 0, 50)
end
