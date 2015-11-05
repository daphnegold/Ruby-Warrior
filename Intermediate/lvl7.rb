
class Player
  HEALTHY = 15
  DIRECTIONS = [:forward, :left, :right, :backward]
  ONWARDS = [:forward, :left, :right]

  def play_turn(warrior)
    @health ||= warrior.health
    @surrounding_enemies = DIRECTIONS.find_all { |dir| warrior.feel(dir).enemy? }
    @needs_binding ||= find_enemies(warrior) - [warrior.direction_of_stairs]
    @captives ||= find_captives(warrior)
    @all_units ||= warrior.listen
    @bomb_alert = find_bombs(warrior)
    @surrounded ||= ONWARDS.find_all { |dir| warrior.feel(dir).enemy? }.length == 3

    if @all_units.empty?
      walk_to_stairs(warrior)
    elsif @bomb_alert
      if !@captives.empty?
        warrior.rescue!(@captives.first)
        @captives.shift
      elsif warrior.feel(direction_of_ticking(warrior)).empty?
        warrior.walk!(direction_of_ticking(warrior))
        walk_swag_reset(warrior)
      elsif @surrounded
        @binding_again ||= ONWARDS - [direction_of_ticking(warrior)]
        if @binding_again.length > 0
          warrior.bind!(@binding_again.first)
          @binding_again.shift
        else
          warrior.attack!(direction_of_ticking(warrior))
        end
      else
        @rand_dir = ONWARDS - [direction_of_ticking(warrior)]
        @rand_dir -= find_walls(warrior) unless find_walls(warrior).nil?
        warrior.walk!(@rand_dir.pop)
        walk_swag_reset(warrior)
      end
    elsif rest_time?(warrior)
        warrior.rest!
    elsif warrior.feel(direction_of_next_unit(warrior)).empty?
      unless warrior.feel(direction_of_next_unit(warrior)).stairs?
        warrior.walk!(direction_of_next_unit(warrior))
        walk_swag_reset(warrior)
      else
        @rand_dir ||= (DIRECTIONS - [warrior.direction_of_stairs]).shuffle
        warrior.walk!(@rand_dir.pop)
        walk_swag_reset(warrior)
      end
    elsif @needs_binding.length > 0 && @surrounding_enemies.length > @needs_binding.length
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

  def find_bombs(warrior)
    @all_units.find { |unit| unit.ticking? }
  end

  def find_walls(warrior)
    ONWARDS.find_all { |dir| warrior.feel(dir).wall? }
  end

  def walk_swag_reset(warrior)
    @needs_binding = nil
    @binding_again = nil
    @captives = nil
  end

  def direction_of_ticking(warrior)
    ticking = @all_units.find { |unit| unit.ticking? }
    warrior.direction_of(ticking)
  end
end
