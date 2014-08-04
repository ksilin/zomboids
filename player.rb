require_relative 'boid'
require_relative 'core_ext'
require_relative 'quad'
require 'matrix'

class Player

  attr_accessor :speed, :color, :location

  def initialize(loc, drawable = Quad.new(20, Gosu::Color.from_hsv(100, 1.0, 1.0)))
    @location = loc
    @speed = Vector[0, 0]
    @drawable = drawable
  end


  def draw(window)
    @drawable.draw(window, location)
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
