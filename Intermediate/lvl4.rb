
class Player
  HEALTHY = 15
  DIRECTIONS = [:forward, :left, :right, :backward]

  def play_turn(warrior)
    @health ||= warrior.health
    @needs_binding ||= find_enemies(warrior) - [warrior.direction_of_stairs]
    @captives ||= find_captives(warrior)
    @all_units ||= warrior.listen

    if @all_units.empty?
      walk_to_stairs(warrior)
    elsif rest_time?(warrior)
        warrior.rest!
    elsif warrior.feel(direction_of_next_unit(warrior)).empty?
      warrior.walk!(direction_of_next_unit(warrior))
      @needs_binding = nil
      @captives = nil
    elsif @needs_binding.length > 0
      warrior.bind!(@needs_binding.first)
      @needs_binding.shift
    elsif @captives.length >= 1
      warrior.rescue!(@captives.first)
      @captives.shift
    else
      if @needs_binding.empty? && enemy_blocking_stairs?(warrior)
        warrior.attack!(warrior.direction_of_stairs)
      else
        warrior.attack!(warrior.direction_of(@all_units.first))
      end
    end

    @health = warrior.health
    @all_units = warrior.listen
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

  def walk_to_stairs(warrior)
    warrior.walk!(warrior.direction_of_stairs)
  end

  def enemy_blocking_stairs?(warrior)
    !warrior.feel(warrior.direction_of_stairs).empty?
  end

  def direction_of_next_unit(warrior)
    warrior.direction_of(@all_units.first)
  end
end
