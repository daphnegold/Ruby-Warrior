class Player
  HEALTHY = 15
  DIRECTIONS = [:forward, :left, :right, :backward]

  def play_turn(warrior)
    @health ||= warrior.health

    attack_direction = DIRECTIONS.find { |direction| !warrior.feel(direction).empty? && !warrior.feel(direction).wall? }
    if attack_direction.nil?
      if rest_time?(warrior)
        warrior.rest!
      else
        warrior.walk!(warrior.direction_of_stairs)
      end
    else
      warrior.attack!(attack_direction)
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
