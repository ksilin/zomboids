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
    @speed[0] = @speed[0].constrain(5)
    @speed[1] = @speed[1].constrain(5)
  end

  def calc_acceleration(other)
    vecX = (other.x - x)
    vecY = (other.y - y)

    dist2 = Math::sqrt(vecX*vecX + vecY*vecY)

    @accX = (vecX/dist2).constrain(5)
    @accY = (vecY/dist2).constrain(5)
  end

  def accelerate
    @speed[0] += @accX
    @speed[1] += @accY
  end

  def move
    self.x += @speed[0]*(0.1 + rand)
    self.y += @speed[1]*(0.1 + rand)
  end
end
