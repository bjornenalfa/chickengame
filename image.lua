image = {}
local i = image

function addImage(name)
  i[name] =  love.graphics.newImage("media/"..name..".png")
end

--addImage("debris")