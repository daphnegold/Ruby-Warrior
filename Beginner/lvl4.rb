class Player
  HEALTHY = 15

  def play_turn(warrior)
    @health ||= warrior.health

    if warrior.feel.empty?
      if rest_time?(warrior)
        warrior.rest!
      else
        warrior.walk!
      end
    else
      warrior.attack!
    end

    @health = warrior.health
  end

  def under_attack?(warrior)
    warrior.health < @health
  end

  def rest_time?(warrior)
    warrior.health < HEALTHY && !under_attack?(warrior)
  end
end
