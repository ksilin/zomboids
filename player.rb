require_relative 'boid'
require_relative 'core_ext'
require_relative 'quad'
require 'matrix'

class Player

  attr_accessor :speed, :acc, :color, :location, :health

  def initialize(loc, drawable = Quad.new(20, Gosu::Color.new(255, 251,242,201)))
    @location = loc
    @speed = Vector[0, 0]
    @drawable = drawable
    @acc_delta = 1
    @max_acc = 5
    @acc = Vector[0, 0]
    @health = 1000
  end

  def update(delta)
    fatigue
    friction
    accelerate
    move
    constrain_location
  end

  def fatigue
    @health -= 1
  end

  def draw(window)
    coeff = [(@health/1000.0), 1].min
    # TODO - extract blend function
    c = Game::PLAYER_COLOR
    d = Game::PLAYER_COLOR_2
    color = Gosu::Color.new(255, c.red*coeff + d.red*(1 - coeff),
                                 c.green*coeff + d.green*(1 - coeff),
                                 c.blue*coeff + d.blue*(1 - coeff))
    @drawable.draw(window, location, Game::Z::Player, color)
  end

  def friction
    @speed *= 0.7
  end

  def accelerate
    @speed += @acc
  end

  def constrain_acc
    @acc = @acc.constrain(@max_acc)
  end

  def move
    self.location += @speed
  end

  def constrain_location
     location.x = 0 if location.x < 0
     location.y = 0 if location.y < 0
     location.x = Game::WIDTH - 20 if location.x > (Game::WIDTH - 20)
     location.y = Game::HEIGHT - 20 if location.y > (Game::HEIGHT - 20)
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

  def button_down(id)
    case id
      when Gosu::KbUp
        move_up
      when Gosu::KbDown
        move_down
      when Gosu::KbLeft
        move_left
      when Gosu::KbRight
        move_right
    end
  end

  def button_up(id)
    case id
      when Gosu::KbUp, Gosu::KbDown
        @acc.y = 0
      when Gosu::KbLeft, Gosu::KbRight
        @acc.x = 0
    end
  end

end
