require 'hasu'

# Hasu.load 'player.rb'
require_relative 'player'


class Game < Hasu::Window

  WIDTH = 640
  HEIGHT = 480

  def initialize
    super(WIDTH, HEIGHT, false)
    @player = Player.new(WIDTH/2, HEIGHT/2, Gosu::Color.from_hsv(0.1, 1.0, 1.0))

    @others = 2.times.map do |i|
      Player.new(WIDTH/(1 + 2*i), HEIGHT/(1 + 2*i), Gosu::Color.from_hsv(0.1, 0.5, 1.0))
    end
  end

  def reset
    @frames = 0
    @elapsed_time = 0
    @font = Gosu::Font.new(self, 'Arial', 24)
  end

  def update
    @frames +=1

    @others.each { |p| p.follow(@player) }

    if button_down? Gosu::KbUp
      @player.y -= 10
    end
    if button_down? Gosu::KbDown
      @player.y += 10
    end

    if button_down? Gosu::KbLeft
      @player.x -= 10
    end
    if button_down? Gosu::KbRight
      @player.x += 10
    end
  end

  def draw
    @player.draw self
    @others.each { |o| o.draw self }
  end

  def needs_cursor?
    true
  end
end

Game.run


