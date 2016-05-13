menu = {}
local m = menu

function m.draw()
  colorInside = {0, 255, 255}
  colorOutside = {0, 0, 255}
  m.drawOutlinedText("Space Battle Supreme", -270, font.h1, 3, colorInside, colorOutside)
  msgList = {"Press Any Key to Start", "",
            "-- Red Player --", "W - Fire", "A and D - Aim", "",
            "-- Blue Player --", "Up - Fire", "Left and Right - Aim"}
  for i = 1, #msgList do
    m.drawOutlinedText(msgList[i], -100 + i * 37, font.base, 2, colorInside, colorOutside)
  end
end

function m.drawOutlinedText(text, y, font, lineWidth, colorInside, colorOutside)
  love.graphics.setFont(font)
  love.graphics.setColor(colorOutside)
  for dx = -lineWidth, lineWidth, lineWidth do
    for dy = -lineWidth, lineWidth, lineWidth do
      love.graphics.printf(text, -400 + dx, y + dy, 800, "center")
    end
  end
  love.graphics.setColor(colorInside)
  love.graphics.printf(text, -400, y, 800, "center")
end