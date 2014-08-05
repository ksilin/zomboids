require 'hasu'
require 'matrix'
Hasu.load 'player.rb'
Hasu.load 'boid.rb'
Hasu.load 'quad.rb'
# require_relative 'player'

class Game < Hasu::Window

  WIDTH = 640
  HEIGHT = 480


  def initialize
    super(WIDTH, HEIGHT, false)
    @center = Vector[WIDTH/2, HEIGHT/2]
    reset_game
    @player_speed = 10
  end

  def reset_game
    @frames = 0
    @elapsed_time = 0
    @font = Gosu::Font.new(self, 'Arial', 24)

    create_player
    create_others
  end

  def create_player
    @player = Player.new(@center)
  end

  def create_others(how_many = 5)
    @others = how_many.times.map do
      on_circle = Vector[rand - 0.5, rand - 0.5].normalize * 500
      puts "center: #{@center}"
      q = Quad.new(20*(0.5 + rand), Gosu::Color.from_hsv(rand(360), rand, 1.0))
      Boid.new(@center + on_circle, Vector[0, 0], q)
    end
  end

  def update
    @frames +=1
    puts "@frames: #{@frames}"

    @others.each { |p| p.follow(@player) }

    if button_down? Gosu::KbUp
      @player.speed.y = -@player_speed
    end
    if button_down? Gosu::KbDown
      @player.speed.y = @player_speed
    end

    if button_down? Gosu::KbLeft
      @player.speed.x = -@player_speed
    end
    if button_down? Gosu::KbRight
      @player.speed.x = @player_speed
    end
    @player.move
    @player.speed = Vector[0, 0]

    if button_down? Gosu::KbSpace
      reset_game
    end

    # OSD

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


