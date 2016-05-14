Game = {} -- random stuff used by everything goes in here

function Game.explode(x, y, r, power, damage)
  Map.circle(x, y, r)
  explosions.new(x, y, 0.3, r, true)
  Character.explosion(x, y, r, power, damage)
end