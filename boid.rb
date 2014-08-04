
class Boid

  attr_accessor :location, :speed, :size, :color, :friction

  def initialize(loc, spd, drawable)
    @location = loc
    @speed = spd
    @force = Vector[0.0, 0.0]
    @drawable= drawable

    @weight = 1.0
    @size = 20
    @friction = 0.9
    @max_speed = 1
    @max_acceleration = 0.5
  end

  def acquire_target

  end

  def calc_force

  end

  def follow(other)
    calc_acceleration(other)
    accelerate
    apply_friction
    constrain_speed
    move
  end

  def calc_acceleration(other)
    # TODO - better contraining - like this, the acc is always = max
    @acc = vec_to(other).normalize * @max_acceleration
  end

  def distance_from(boid)
    vec_to(boid).r
  end

  def vec_to(obj)
    obj.location - self.location
  end

  def constrain_speed
    # TODO - better contraining - like this, the speed is always = max
    @speed.normalize * @max_speed
  end

  def apply_friction
    @speed *= friction
  end

  def draw(window)
    @drawable.draw(window, location)
  end

  def accelerate
    @speed += @acc
    @speed += Vector[rand - 0.5, rand - 0.5].normalize
  end

  def move
    self.location += @speed
  end

end