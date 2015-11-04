class Player
    def play_turn(warrior)
    @direction ||= :forward

    if warrior.feel(@direction).wall?
      warrior.pivot!
    elsif warrior.feel(@direction).empty?
      if warrior.health == 20 || (warrior.health < @health && warrior.health > 10)
        warrior.walk!(@direction)
      elsif warrior.health < @health
        warrior.walk!(:backward)
      else
        warrior.rest!
      end
    elsif warrior.feel(@direction).captive?
      warrior.rescue!(@direction)
    elsif warrior.health > 10
      warrior.attack!(@direction)
    else
      warrior.walk!(:backward)
    end

    @health = warrior.health
  end
end
