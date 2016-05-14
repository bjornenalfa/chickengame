turn = {}
local t = turn

t.playerOrder = {}
t.currentPlayerIndex = 0
t.currentPlayer = nil
t.currentCharacter = nil

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

function turn.nextTurn(depth)
  if depth == nil then depth = 0 end
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
    if depth > #t.playerOrder then
      print("oh it is game over")
      return
    end
    print("next player has no characters left?")
    return turn.nextTurn(depth+1)
  end
  oldest.lastTurn = t.turnNumber
  t.currentCharacter = oldest
  camera.trackEntity(oldest)
  t.timerActive = true
  t.turnTimer = t.turnTime
end

function turn.keypressed(key)
  
end

function turn.update(dt)
  t.turnTimer = t.turnTimer - dt
  if t.turnTimer <= 0 then
    t.endTurn()
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

function turn.draw()
  love.graphics.setColor(0,0,0)
  love.graphics.setFont(font.base)
  love.graphics.print(math.ceil(t.turnTimer), 0, 0)
  love.graphics.setFont(font.normal)
  if t.currentCharacter then
    char = t.currentCharacter
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("line",char.x-char.r, char.y-char.r, char.r*2, char.r*2)
  end
end
