Weapon = {}
local w = Weapon

weapons = {
  mine=function()
    Mine.new(t.currentCharacter.x, t.currentCharacter.y)
  end,
}

w.list = {"missile", "mine", "grenade", "wall", "punch"}

w.missile = {image = image.bazooka}
w.mine = {image = image.egg}
w.grenade = {image = image.grenade_unarmed}
w.wall = {}
w.punch = {image = image.zombie_fist}

w.tracking = nil
w.lastWeapon = nil

function Weapon.activate(weapon, x, y, power, angle, owner)
  w.lastWeapon = weapon
  if weapon == "missile" then
    pr = projectile.new(image.bazooka_missile, x + math.cos(angle)*25, char.y + math.sin(angle)*25, 10, 30, power, angle, 50, owner, 200, 50)
    w.tracking = pr
    camera.trackEntity(pr)
    
  elseif weapon == "mine" then
    Mine.new(x, y)
    
  elseif weapon == "grenade" then
    gr = Grenade.new(x, y, power, angle)
    w.tracking = gr
    camera.trackEntity(gr)
    sound.play("grenade_throw")
    
  elseif weapon == "wall" then
    Map.line(x, y, x + math.cos(angle)*(5+power*0.2), y + math.sin(angle)*(5+power*0.2), 10)
    
  elseif weapon == "punch" then
    
  end
end

function Weapon.done(dt)
  local weapon = w.lastWeapon
  if weapon == "missile" then
    moving, thing = Game.stuffMoving()
    if moving then
      camera.trackEntity(thing)
      return false
    end
    return w.tracking.remove
  elseif weapon == "mine" then
    return true
  elseif weapon == "grenade" then
    moving, thing = Game.stuffMoving()
    if moving then
      camera.trackEntity(thing)
      return false
    end
    return w.tracking.dead
  elseif weapon == "wall" then
    return true
  elseif weapon == "punch" then
    moving, thing = Game.stuffMoving()
    if moving then
      camera.trackEntity(thing)
      return false
    end
    return true
  end
end

function Weapon.draw(weapon, x, y, angle)
  print(weapon)
  local img = w[weapon].image or w.missile.image
  love.graphics.setColor(255,255,255)
  if math.cos(angle) < 0 then
    love.graphics.draw(img, x, y, angle - math.pi, -1, 1, img:getWidth()/2, img:getHeight()/2)
  else
    love.graphics.draw(img, x, y, angle, 1, 1, img:getWidth()/2, img:getHeight()/2)
  end
end