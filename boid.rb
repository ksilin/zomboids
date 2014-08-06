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
    @max_speed = options[:max_speed] || 5
    @max_acceleration = options[:max_acceleration] || 0.5
  end

  def follow(other)
    calc_acceleration(other)
    calc_speed
    move
  end

  def calc_acceleration(other)
    @acc = vec_to(other).constrain(@max_acceleration)
    @acc += Vector[rand - 0.5, rand - 0.5].normalize
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
    @drawable.draw(window, location)
  end

  def accelerate
    @speed += @acc
  end

  def move
    # puts "location: #{location}, speed: #{@speed}"
    self.location += @speed
  end

end