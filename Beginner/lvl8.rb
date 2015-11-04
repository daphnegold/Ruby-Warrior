class Player
  HEALTHY = 15
  FLEE = 8

  def play_turn(warrior)
    @health ||= warrior.health
    @direction ||= :forward
    @fled ||= false
    @found_wall ||= false

    if warrior.feel(@direction).empty?
      if shoot?(warrior)
        warrior.shoot!
      elsif rest_time?(warrior)
        warrior.rest!
        switch_direction(warrior) if @fled && @found_wall
        @fled = false
      elsif flee?(warrior)
        switch_direction(warrior) unless @fled
        @fled = true
        warrior.walk!(@direction)
      else
        warrior.walk!(@direction)
      end
    elsif warrior.feel(@direction).captive?
      warrior.rescue!(@direction)
    elsif warrior.feel(@direction).wall?
      warrior.pivot!
      @found_wall = true
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

  def switch_direction(warrior)
    case @direction
    when :forward then @direction = :backward
    when :backward then @direction = :forward
    end
  end

  def flee?(warrior)
    warrior.health < FLEE
  end

  def shoot?(warrior)
    @next_thing = warrior.look(@direction).find { |i| i.enemy? || i.captive? }

    @next_thing.enemy? if !@next_thing.nil?
  end

end
