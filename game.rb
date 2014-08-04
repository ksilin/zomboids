require 'hasu'
require 'matrix'
Hasu.load 'player.rb'
# require_relative 'player'

class Game < Hasu::Window

  WIDTH = 640
  HEIGHT = 480

  def initialize
    super(WIDTH, HEIGHT, false)
    @center = Vector[WIDTH/2, HEIGHT/2]
    reset
  end

  def reset
    @frames = 0
    @elapsed_time = 0
    @font = Gosu::Font.new(self, 'Arial', 24)

    create_player
    create_others
  end

  def create_player
    @player = Player.new(@center, Gosu::Color.from_hsv(100, 1.0, 1.0))
  end

  def create_others(how_many = 5)
    @others = how_many.times.map do
      on_circle = Vector[rand - 0.5, rand - 0.5].normalize * 500
      Player.new(@center + on_circle, Gosu::Color.from_hsv(rand(360), rand, 1.0))
    end
  end

  def update
    @frames +=1

    @others.each { |p| p.follow(@player) }

    if button_down? Gosu::KbUp
      @player.location.y -= 10
    end
    if button_down? Gosu::KbDown
      @player.location.y += 10
    end

    if button_down? Gosu::KbLeft
      @player.location.x -= 10
    end
    if button_down? Gosu::KbRight
      @player.location.x += 10
    end
    if button_down? Gosu::KbSpace
      reset
    end
  end

  def draw
    @player.draw self
    @others.each { |o| o.draw self }
    @font.draw("#{@frames}", 0, 0, 0)
  end

  def needs_cursor?
    true
  end
end

Game.run


