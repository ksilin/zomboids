require_relative 'boid'
require_relative 'core_ext'
require_relative 'quad'
require 'matrix'

class Player

  attr_accessor :speed, :acc, :color, :location

  def initialize(loc, drawable = Quad.new(20, Gosu::Color.from_hsv(100, 1.0, 1.0)))
    @location = loc
    @speed = Vector[0, 0]
    @drawable = drawable
    @acc_delta = 1
    @max_acc = 5
    @acc = Vector[0, 0]
  end


  def draw(window)
    @drawable.draw(window, location)
  end

  def friction
    @speed *= 0.9
  end

  def accelerate
    @speed += @acc
  end

   def constrain_acc
     @acc = @acc.contrain(@max_acc)
   end

  def move
    self.location += @speed
  end

  def move_up
    @acc.y = -@acc_delta
  end

  def move_down
    @acc.y = @acc_delta
  end

  def move_left
    @acc.x = -@acc_delta
  end

  def move_right
    @acc.x = @acc_delta
  end

end
