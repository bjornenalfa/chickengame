CAMERA_MOVE_DOWN = {keyboard={"down"}, gamepad={}, axisIf={{"righty", function(i) return i > 0.2 end}}}
CAMERA_MOVE_UP = {keyboard={"up"}, gamepad={}, axisIf={{"righty", function(i) return i < -0.2 end}}}
CAMERA_MOVE_LEFT = {keyboard={"left"}, gamepad={}, axisIf={{"rightx", function(i) return i < -0.2 end}}}
CAMERA_MOVE_RIGHT = {keyboard={"right"}, gamepad={}, axisIf={{"rightx", function(i) return i > 0.2 end}}}
CAMERA_RESET = {keyboard={"h"}, gamepad={"rightshoulder"}, axisIf={}}
CHARACTER_START_AIM = {keyboard={"space"}, gamepad={"x"}, axisIf={}}
CHARACTER_FIRE = {keyboard={"f"}, gamepad={"x"}, axisIf={}}
CHARACTER_JUMP = {keyboard={"w"}, gamepad={"a"}, axisIf={}}
CHARACTER_STOP_AIM = {keyboard={"space"}, gamepad={"b"}, axisIf={}}
CHARACTER_MOVE_LEFT = {keyboard={"a"}, gamepad={}, axisIf={{"leftx", function(i) return i < -0.2 end}}}
CHARACTER_MOVE_RIGHT = {keyboard={"d"}, gamepad={}, axisIf={{"leftx", function(i) return i > 0.2 end}}}
CHARACTER_AIM_LEFT = {keyboard={"a"}, gamepad={}, axisIf={}}
CHARACTER_AIM_RIGHT = {keyboard={"d"}, gamepad={}, axisIf={}}
CHARACTER_AIM_STRENGTH_UP = {keyboard={"w"}, gamepad={}, axisIf={{"triggerright", function(i) return i > 0 end}}}
CHARACTER_AIM_STRENGTH_DOWN = {keyboard={"s"}, gamepad={}, axisIf={{"triggerleft", function(i) return i > 0 end}}}
END_TURN = {keyboard={"k"}, gamepad={"y"}}
NEXT_WEAPON = {keyboard={"l"}, gamepad={"dpup"}}
PREV_WEAPON = {keyboard={"h"}, gamepad={"dpdown"}}

-- Returns whether the keyboard or the current player's gamepad has a specific input
function hasInput(inputs, player)
  if not turn.playerinput then return false end
  player = player or turn.currentPlayer
  inputs = inputs or {}
  local stick = player.joystick
  if stick then
    inputs["gamepad"] = inputs["gamepad"] or {}
    inputs["axisIf"] = inputs["axisIf"] or {}
    for _, gpInput in pairs(inputs["gamepad"]) do
      if type(gpInput) == "string" and stick:isGamepadDown(gpInput) then return true, 1 end
    end
    for _, axInput in pairs(inputs["axisIf"]) do
      local val = stick:getGamepadAxis(axInput[1])
      if axInput[2](val) then return true, val end
    end
  else
    inputs["keyboard"] = inputs["keyboard"] or {}
    for _,kbInput in pairs(inputs["keyboard"]) do
      if type(kbInput) == "string" and love.keyboard.isDown(kbInput) then return true, 1 end
    end
  end
  return false
end