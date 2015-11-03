class Player
  def initialize
    @direction = :backward
  end

  def play_turn(warrior)
    if warrior.feel(@direction).wall?
      @direction = :forward
    end

    if warrior.feel(@direction).empty?
      if warrior.health == 20 || (warrior.health < @health && warrior.health > 10)
        warrior.walk!(@direction)
      elsif warrior.health < @health
        warrior.walk!(:backward)
      else
        warrior.rest!
      end
    elsif warrior.feel(@direction).captive?
      warrior.rescue!(@direction)
    else
      warrior.attack!(@direction)
    end

    @health = warrior.health
  end
end
