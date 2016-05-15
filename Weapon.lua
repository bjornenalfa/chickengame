Weapon = {}
local w = Weapon

weapons = {
  mine=function()
    Mine.new(t.currentCharacter.x, t.currentCharacter.y)
  end,
}
currentWeapon = "missile"

w.list = {"missile", "mine", "grenade"}

w.missile = {image = image.bazooka}
w.mine = {image = image.egg}
w.grenade = {image = image.grenade_unarmed}

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
  end
end

function Weapon.draw(weapon, x, y, angle)
  local img = w[weapon].image or w.missile.image
  love.graphics.setColor(255,255,255)
  love.graphics.draw(img, x, y, angle or 0, 1, 1, img:getWidth()/2, img:getHeight()/2)
end