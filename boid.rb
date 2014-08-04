class Boid

  attr_accessor :location, :speed, :size, :color, :friction

  def initialize(loc, spd)
    @location = loc
    @speed = spd
    @force = Vector[0.0, 0.0]

    @color = Gosu::Color.from_hsv(rand(360), rand, 1.0)

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
    vec_to(boid.location).r
  end

  def vec_to(vector)
    vector.location - self.location
  end

  def constrain_speed
    # TODO - better contraining - like this, the speed is always = max
    @speed.normalize * @max_speed
  end

  def left
    location.x
  end

  def right
    location.x + size
  end

  def top
    location.y
  end

  def bottom
    location.y + size
  end

  def apply_friction
    @speed *= friction
  end

  def draw(window)
    window.draw_quad(
        left, top, color,
        right, top, color,
        right, bottom, color,
        left, bottom, color)
  end

  def accelerate
    @speed += @acc
    @speed += Vector[rand - 0.5, rand - 0.5].normalize
  end

  def move
    self.location += @speed
  end

end