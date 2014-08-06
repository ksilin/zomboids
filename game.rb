require 'hasu'
require 'matrix'
Hasu.load 'player.rb'
Hasu.load 'boid.rb'
Hasu.load 'quad.rb'
Hasu.load 'osd.rb'
# require_relative 'player'

class Game < Hasu::Window

  WIDTH = 640
  HEIGHT = 480

  attr_reader :player, :others, :frames


  def initialize
    super(WIDTH, HEIGHT, false)
    @center = Vector[WIDTH/2, HEIGHT/2]
    @player_speed = 10
    @cherry = Gosu::Image.new(self, 'assets/graphics/PM_Cherry.png')
    @background_music = Gosu::Song.new(self, 'assets/audio/background.ogg')
    @background_music.volume = 0.25
    reset_game
  end

  def reset_game
    @frames = 0
    @elapsed_time = 0
    @last_frame_start = Time.now
    @font = Gosu::Font.new(self, 'Arial', 24)

    @background_music.play(true)

    create_player
    create_others
    create_osd
  end

  def create_osd
    q = Quad.new(120, Gosu::Color.new(100, 20, 20, 20), Gosu::Color.new(120, 80, 80, 80))
    @osd = OSD.new(Vector[0, 0], q, @font)
  end

  def create_player
    @player = Player.new(@center)
  end

  def create_others(how_many = 5)
    @others = how_many.times.map do
      on_circle = Vector[rand - 0.5, rand - 0.5].normalize * 500
      q = Quad.new(20*(0.5 + rand), Gosu::Color.from_hsv(rand(360), rand, 1.0))
      Boid.new(@center + on_circle, Vector[0, 0], q)
    end
  end

  def update
    @frames +=1
    @elapsed_time += (Time.now - @last_frame_start)
    @last_frame_start = Time.now

    @others.each { |p| p.follow(@player) }

    @player.friction
    @player.accelerate
    @player.move
    @player.constrain_location

    @osd.data = { :frames => @frames, :elapsed => '%.2f' % @elapsed_time }
  end

  def draw
    @cherry.draw(@center.x, @center.y, 0, 0.5, 0.5)
    @player.draw(self)
    @others.each { |o| o.draw(self) }
    @osd.draw(self)
  end

  def needs_cursor?
    true
  end

  def button_down(id)
    case id
      when Gosu::KbSpace
        reset_game
      when Gosu::KbM
        @background_music.paused? ? @background_music.play(true) : @background_music.pause
    end
    @player.button_down(id)
    @osd.button_down(id)
  end

  def button_up(id)
    @player.button_up(id)
    @osd.button_up(id)
  end

end

$game = Game.run

