ui = {}

function ui.draw() 
  love.graphics.origin()
  turn.uidraw()
  
  p1chars = {}
  p1total = 0
  p1max = 0
  p2chars = {}
  p2total = 0
  p2max = 0
  for i,char in pairs(Character.list) do
    if char.owner == player1 then
      table.insert(p1chars, char)
      p1total = p1total + char.hp
      p1max = p1max + char.maxhp
    elseif char.owner == player2 then
      table.insert(p2chars, char)
      p2total = p2total + char.hp
      p2max = p2max + char.maxhp
    end
  end
  
  bottomy = love.graphics.getHeight() - 25
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("line",5,bottomy-25,60,20)
  love.graphics.setColor(180,180,180)
  love.graphics.rectangle("fill",5,bottomy-25,60,20)
  love.graphics.setColor(255,0,0)
  love.graphics.rectangle("fill",7,bottomy-23,56*(p1total/p1max),16)
  love.graphics.setColor(0,0,0)
  local x = 7
  for i,char in pairs(p1chars) do
    x = x + 56 * (char.hp/p1max)
    if x > 55 then break end
    love.graphics.rectangle("fill",x,bottomy-23,1,16)
  end
  love.graphics.setColor(255,255,255,128)
  love.graphics.print("chickens",7,bottomy-21)
  
  bottomy = bottomy - 25
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("line",5,bottomy-25,60,20)
  love.graphics.setColor(180,180,180)
  love.graphics.rectangle("fill",5,bottomy-25,60,20)
  love.graphics.setColor(255,0,0)
  love.graphics.rectangle("fill",7,bottomy-23,56*(p2total/p2max),16)
  love.graphics.setColor(0,0,0)
  local x = 7
  for i,char in pairs(p2chars) do
    x = x + 56 * (char.hp/p2max)
    if x > 55 then break end
    love.graphics.rectangle("fill",x,bottomy-23,1,16)
  end
  love.graphics.setColor(255,255,255,128)
  love.graphics.print("zombies",10,bottomy-21)
end