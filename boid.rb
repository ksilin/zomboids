class Boid

  attr_accessor :location, :speed, :size, :color, :friction

  def initialize(loc, spd, drawable, options = {})
    @location = loc
    @speed = spd
    @drawable= drawable

    @force = Vector[0.0, 0.0]

    @weight = options[:weight] || 1.0
    @size = options[:size] || 20
    @friction = options[:friction] ||0.9
    @max_speed = options[:max_speed] || 2
    @max_acceleration = options[:max_acceleration] || 0.5
  end

  def follow(other)
    calc_follow_target_vector(other)
    move
  end

  def flee(other)
    calc_flee_target_vector(other)
    move
  end

  def calc_follow_target_vector(other)
    @target_vector = vec_to(other)
  end

  def calc_flee_target_vector(other)
    @target_vector = other.vec_to(self)
  end

  def calc_acceleration
    @acc = @target_vector.constrain(@max_acceleration)
    @acc += Vector[rand - 0.5, rand - 0.5].constrain(@max_acceleration*5)
  end

  def distance_from(boid)
    vec_to(boid).r
  end

  def vec_to(obj)
    obj.location - self.location
  end

  def calc_speed
    apply_friction
    accelerate
    constrain_speed
  end

  def constrain_speed
    @speed = @speed.constrain(@max_speed)
  end

  def apply_friction
    @speed *= friction
  end

  def draw(window)
    if (:enemy_fear == $game.state)
      @drawable.draw(window, location, Game::Z::Others, Game::ENEMY_FEAR)
    else
      @drawable.draw(window, location)
    end
  end

  def accelerate
    @speed += @acc
  end

  def move
    calc_acceleration
    calc_speed
    # puts "location: #{location}, speed: #{@speed}"
    self.location += @speed
  end

end