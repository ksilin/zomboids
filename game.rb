require 'hasu'
require 'matrix'
Hasu.load 'player.rb'
Hasu.load 'boid.rb'
Hasu.load 'quad.rb'
Hasu.load 'osd.rb'
# require_relative 'player'

class Game < Hasu::Window

  module Z
    Background, Others, Player, UI = *0..3
  end

  WIDTH = 640
  HEIGHT = 480

  # TOP_COLOR = Gosu::Color.new(255, 94,82,58)
  TOP_COLOR = Gosu::Color.new(255, 23,4,9)
  BOTTOM_COLOR = Gosu::Color.new(255, 61,51,39)
  TITLE = 'Zomboid - a Gosu skeleton'

  PALETTE = [Gosu::Color.new(255,0,90,63),
             Gosu::Color.new(255,0,131,94),
             Gosu::Color.new(255,0,171,128),
             Gosu::Color.new(255,249,14,97),
             Gosu::Color.new(255,251,64,64)
  ]

  attr_reader :player, :others, :frames


  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = TITLE

    @center = Vector[WIDTH/2, HEIGHT/2]
    @player_speed = 10
    @cherry = Gosu::Image.new(self, 'assets/graphics/PM_Cherry.png')
    @background_music = Gosu::Song.new(self, 'assets/audio/background.ogg')
    @background_music.volume = 0.1

    @animation = (1..6).map{|i| Gosu::Image.new(self, "assets/graphics/bob-#{i}.png")}
    @animation_length = 350
    @current_animation_pos = 0

    reset_game
  end

  def reset_game
    @frames = 0
    @elapsed_time = 0

    @current_animation_pos = 0

    @last_frame_start = Gosu::milliseconds
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
      q = Quad.new(20*(0.5 + rand), PALETTE[rand(PALETTE.size)])
      Boid.new(@center + on_circle, Vector[0, 0], q)
    end
  end

  def update
    @frames +=1
    delta = (Gosu::milliseconds - @last_frame_start)
    @fps = 1000 / delta if delta > 0
    @elapsed_time += delta
    @last_frame_start = Gosu::milliseconds

    @current_animation_pos += delta
    if @current_animation_pos > @animation_length
      @current_animation_pos = 0
    end

    @others.each { |p| p.follow(@player) }

    @player.friction
    @player.accelerate
    @player.move
    @player.constrain_location

    @osd.data = { :frames => @frames, :seconds => '%.2f' % (@elapsed_time/1000), :fps =>  '%.2f' % @fps}
  end

  def draw
    draw_background
    @cherry.draw(@center.x, @center.y, 0, 0.5, 0.5)

    idx = ([@animation.size - 1, (@animation.size) * @current_animation_pos/@animation_length].min)
    img_to_draw = @animation[idx]
    img_to_draw.draw(WIDTH - 32, HEIGHT - 32, 0, 1, 1, Gosu::Color::GREEN)

    @player.draw(self)
    @others.each { |o| o.draw(self) }
    @osd.draw(self)
  end

  def draw_background
    draw_quad(
        0, 0, TOP_COLOR,
        WIDTH, 0, TOP_COLOR,
        0, HEIGHT, BOTTOM_COLOR,
        WIDTH, HEIGHT, BOTTOM_COLOR,
        Z::Background
    )
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

