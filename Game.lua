Game = {} -- random stuff used by everything goes in here

Game.gravity = 300

function Game.explode(x, y, r, power, damage)
  Map.circle(x, y, r)
  explosions.new(x, y, 0.3, r, true)
  Character.explosion(x, y, r, power, damage)
  Object.explosion(x, y, r, power)
end

function Game.endGame()
  return error("Game over!")
end

function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h, s, v = h/256*6, s/255, v/255
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255
end

-- Returns whether the keyboard or the current player's gamepad has a specific input
function hasInput(inputs)
  if not turn.playerinput then return end
  inputs = inputs or {}
  inputs["keyboard"] = inputs["keyboard"] or {}
  inputs["gamepad"] = inputs["gamepad"] or {}
  for _,kbInput in pairs(inputs["keyboard"]) do
    if type(kbInput) == "string" and love.keyboard.isDown(kbInput) then return true end
  end
  local stick = turn.currentPlayer.joystick
  if stick then
    for _, gpInput in pairs(inputs["gamepad"]) do
      if type(gpInput) == "string" and stick:isGamepadDown(gpInput) then return true end
    end
  end
  return false
end