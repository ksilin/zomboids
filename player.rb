require_relative 'movable'
require_relative 'core_ext'

Player = Struct.new(:x, :y, :color) do

  def left
    x
  end

  def right
    x + 20
  end

  def top
    y
  end

  def bottom
    y + 20
  end

  def follow(other)
    @speed ||= [0, 0]

    calc_acceleration(other)
    accelerate
    friction
    constrain_speed
    move
  end

  def draw(window)
    window.draw_quad(
        left, top, color,
        right, top, color,
        right, bottom, color,
        left, bottom, color)
  end

  def constrain_speed
    @speed[0] = @speed[0].constrain(2)
    @speed[1] = @speed[1].constrain(2)
  end

  def calc_acceleration(other)
    vecX = (other.x - self.x)
    vecY = (other.y - self.y)

    dist2 = Math.sqrt(Float::EPSILON + vecX*vecX + vecY*vecY)
    @accX = (vecX/dist2).constrain(1)
    @accY = (vecY/dist2).constrain(1)
  end

  def friction
    @speed[0] *= 0.9
    @speed[1] *= 0.9
  end

  def accelerate
    @speed[0] += @accX
    @speed[1] += @accY
  end

  def move
    self.x += @speed[0]
    self.y += @speed[1]
  end
end
