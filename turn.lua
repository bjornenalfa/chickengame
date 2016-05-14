turn = {}
local t = turn

t.playerOrder = {}
t.currentPlayerIndex = 0
t.currentPlayer = nil
t.currentCharacter = nil

t.turnNumber = 0

function turn.setPlayerOrder(...)
  t.playerOrder = {...}
end

function turn.endTurn()
  
end

function turn.nextTurn()
  t.turnNumber = t.turnNumber + 1
  t.currentPlayerIndex = (t.currentPlayerIndex + 1) % #t.playerOrder
  t.currentPlayer = t.playerOrder[t.currentPlayerIndex]
  oldest = nil
  for i,char in pairs(Character.list) do
    if char.owner == t.currentPlayer and oldest == nil or char.lastTurn < oldest.lastTurn then
      oldest = char
    end
  end
  if oldest == nil then
    print("next player has no characters left?")
  end
  t.currentCharacter = oldest
end

function turn.keypressed(key)
  
end

function turn.update(dt)
  
end

function turn.draw()
  if t.currentCharacter then
    char = t.currentCharacter
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("line",char.x-char.r, char.y-char.r, char.r*2, char.r*2)
  end
end
