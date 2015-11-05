class Player
  HEALTHY = 15
  DIRECTIONS = [:forward, :left, :right, :backward]

  def play_turn(warrior)
    @health ||= warrior.health
    @enemies ||= find_enemies(warrior) - [warrior.direction_of_stairs]
    @captives ||= find_captives(warrior)

    if warrior.feel(warrior.direction_of_stairs).empty?
      if rest_time?(warrior)
        warrior.rest!
      else
        warrior.walk!(warrior.direction_of_stairs)
      end
    elsif @enemies.length > 0
      warrior.bind!(@enemies.first)
      @enemies.shift
    elsif @captives.length >= 1
      warrior.rescue!(@captives.first)
      @captives.shift
    else
      warrior.attack!(warrior.direction_of_stairs)
    end

    @health = warrior.health
  end

  def under_attack?(warrior)
    warrior.health < @health
  end

  def rest_time?(warrior)
    warrior.health < HEALTHY && !under_attack?(warrior)
  end

  def find_enemies(warrior)
    DIRECTIONS.find_all { |direction| warrior.feel(direction).enemy? }
  end

  def find_captives(warrior)
    DIRECTIONS.find_all { |direction| warrior.feel(direction).captive? }
  end
end
