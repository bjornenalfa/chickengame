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

function turn.setPlayerOrder(...)
  t.playerOrder = {...}
end

function turn.endTurn()
  turn.nextTurn()
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
      elseif char.lastTurn < oldest.lastTurn then
        oldest = char
      end
    end
  end
  if oldest == nil then
    if #Character.list == 0 then
      print("oh it is game over")
      return
    end
    print("next player has no characters left?")
    return turn.nextTurn()
  end
  oldest.lastTurn = t.turnNumber
  t.currentCharacter = oldest
  camera.followEntity(t.currentCharacter)
  t.timerActive = true
  t.turnTimer = t.turnTime
  t.aiming = false
  t.aimAngle = 0
end

function turn.keypressed(key)
  if key == "space" then
    if not t.aiming then
      t.aiming = true
    else
      t.aiming = false
    end
  end
end

function turn.update(dt)
  t.turnTimer = t.turnTimer - dt
  if t.turnTimer <= 0 then
    t.endTurn()
  end
  
  if t.currentCharacter then
    if t.aiming then
      if love.keyboard.isDown("a") then
        t.aimAngle = t.aimAngle - 2*dt
      end
      if love.keyboard.isDown("d") then
        t.aimAngle = t.aimAngle + 2*dt
      end
    else
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
  love.graphics.setColor(0,0,0)
  love.graphics.setFont(font.base)
  love.graphics.print(math.ceil(t.turnTimer), 0, 0)
  love.graphics.setFont(font.normal)
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
