require_relative 'movable'
require_relative 'core_ext'
require 'matrix'

Player = Struct.new(:location, :color) do

  def left
    location.x
  end

  def right
    location.x + 20
  end

  def top
    location.y
  end

  def bottom
    location.y + 20
  end

  def follow(other)
    @speed ||= Vector[0, 0]

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
    @speed.normalize
  end

  def calc_acceleration(other)
    @acc = (other.location - self.location).normalize * 0.5
  end

  def friction
    @speed *= 0.9
  end

  def accelerate
    @speed += @acc
    @speed += Vector[rand - 0.5, rand - 0.5].normalize
  end

  def move
    self.location += @speed
  end
end
