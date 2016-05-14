CAMERA_MOVE_DOWN = {keyboard={"down"}, gamepad={"dpdown"}}
CAMERA_MOVE_UP = {keyboard={"up"}, gamepad={"dpup"}}
CAMERA_MOVE_LEFT = {keyboard={"left"}, gamepad={"dpleft"}}
CAMERA_MOVE_RIGHT = {keyboard={"right"}, gamepad={"dpright"}}
CAMERA_RESET = {keyboard={"h"}, gamepad={"rightshoulder"}}
CHARACTER_START_AIM = {keyboard={"space"}, gamepad={"x"}}
CHARACTER_FIRE = {keyboard={"f"}, gamepad={"x"}}
CHARACTER_JUMP = {keyboard={"w"}, gamepad={"a"}}
CHARACTER_STOP_AIM = {keyboard={"space"}, gamepad={"b"}}
CHARACTER_MOVE_LEFT = {keyboard={"a"}, gamepad={}}
CHARACTER_MOVE_RIGHT = {keyboard={"d"}, gamepad={}}
CHARACTER_AIM_LEFT = {keyboard={"a"}, gamepad={}}
CHARACTER_AIM_RIGHT = {keyboard={"d"}, gamepad={}}
CHARACTER_AIM_STRENGTH_UP = {keyboard={"w"}, gamepad={}}
CHARACTER_AIM_STRENGTH_DOWN = {keyboard={"s"}, gamepad={}}
END_TURN = {keyboard={"k"}, gamepad={"y"}}
ACTION_PLACE_MINE = {keyboard={"m"}, gamepad={}}

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