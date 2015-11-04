class Player
  def play_turn(warrior)
    @direction ||= :forward
    @health ||= warrior.health

    next_thing = warrior.look(@direction).find { |i| i.enemy? || i.captive? }

    if warrior.feel(@direction).wall?
      warrior.pivot!
    elsif warrior.feel(@direction).empty?
      if !next_thing.nil? && warrior.health >= @health && next_thing.enemy?
        warrior.shoot!
      elsif warrior.health == 20 || (warrior.health < @health && warrior.health > 4)
        warrior.walk!(@direction)
      elsif warrior.health < @health
        warrior.walk!(:backward)
      else
        warrior.rest!
      end
    elsif warrior.feel(@direction).captive?
      warrior.rescue!(@direction)
    elsif warrior.health > 4
      warrior.attack!(@direction)
    else
      warrior.walk!(:backward)
    end

    @health = warrior.health
  end
end
