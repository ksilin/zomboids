require_relative 'boid'
require_relative 'core_ext'
require 'matrix'

class Player

  attr_accessor :speed, :color, :location

  def initialize(loc, color)
    @location = loc
    @speed = Vector[0, 0]
    @color = color
  end


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

  def draw(window)
    window.draw_quad(
        left, top, color,
        right, top, color,
        right, bottom, color,
        left, bottom, color)
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
