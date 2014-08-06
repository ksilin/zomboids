require 'hasu'
require 'matrix'
Hasu.load 'player.rb'
Hasu.load 'boid.rb'
Hasu.load 'quad.rb'
Hasu.load 'osd.rb'
Hasu.load 'animation.rb'
# require_relative 'player'

class Game < Hasu::Window

  module Z
    Background, Others, Player, UI = *0..3
  end

  WIDTH = 640
  HEIGHT = 480

  # TOP_COLOR = Gosu::Color.new(255, 94,82,58)
  TOP_COLOR = Gosu::Color.new(255, 23, 4, 9)
  BOTTOM_COLOR = Gosu::Color.new(255, 61, 51, 39)
  TITLE = 'Zomboid - a Gosu skeleton'

  PLAYER_COLOR = Gosu::Color.from_hsv(147, 0.79, 0.97)
  PLAYER_COLOR_2 = Gosu::Color.from_hsv(347, 0.78, 0.89)
  ENEMY_COLOR = Gosu::Color.from_hsv(57, 0.98, 0.72)
  ENEMY_FEAR = Gosu::Color.from_hsv(300, 0.98, 0.72)

  CHERRY_HEALTH = 800
  ZOMBIE_BITE = 10

  PALETTE = [Gosu::Color.new(255, 0, 90, 63),
             Gosu::Color.new(255, 0, 131, 94),
             Gosu::Color.new(255, 0, 171, 128),
             Gosu::Color.new(255, 249, 14, 97),
             Gosu::Color.new(255, 251, 64, 64)
  ]

  attr_reader :player, :others, :frames, :paused, :state


  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = TITLE

    @center = Vector[WIDTH/2, HEIGHT/2]
    @player_speed = 10
    @cherry = Gosu::Image.new(self, 'assets/graphics/PM_Cherry.png')

    @background_music = Gosu::Song.new(self, 'assets/audio/background.ogg')
    @background_music.volume = 0.1

    @animation = Animation.new((1..6).map { |i| Gosu::Image.new(self, "assets/graphics/bob-#{i}.png") }, 350)
    reset_game
  end

  def reset_game
    @paused = false
    @frames = 0
    @elapsed_time = 0
    @state_time = 0

    @current_animation_pos = 0

    @last_frame_start = Gosu::milliseconds
    @font = Gosu::Font.new(self, 'Arial', 24)

    @background_music.play(true)

    create_player
    create_others
    create_osd
    @cherries = [Vector[WIDTH - 100, 50]]

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
      on_circle = Vector[rand - 0.5, rand - 0.5].normalize * 300
      q = Quad.new(20*(0.5 + rand), ENEMY_COLOR) # PALETTE[rand(PALETTE.size)])
      Boid.new(@center + on_circle, Vector[0, 0], q)
    end
  end

  def update
    @frames +=1
    delta = (Gosu::milliseconds - @last_frame_start)

    @fps = 1000 / delta if delta > 0
    @elapsed_time += delta
    @state_time += delta

    if(:enemy_fear == @state && @state_time > 3000)
      @state = :snafu
    end

    @last_frame_start = Gosu::milliseconds

    @osd.data = { :frames => @frames,
                  :health => @player.health,
                  :seconds => '%.2f' % (@elapsed_time/1000),
                  :fps => '%.2f' % @fps }

    return if @paused

    @animation.update(delta)

    if (:enemy_fear == @state)
      @others.each { |p| p.flee(@player) }
    else
      @others.each { |p| p.follow(@player) }
    end

    @player.update(delta)

    @eating_cherries = @cherries.select { |c| (c - player.location).r < 20 }

    @eating_cherries.each { |c|
      puts 'eating a cherry'
      @player.health += CHERRY_HEALTH
      @state = :enemy_fear
      @state_time = 0
    }
    @cherries -= @eating_cherries

    @touching_enemies = @others.select { |o| (o.location - player.location).r < 20 }

    @touching_enemies.each { |c|
      if (:enemy_fear == @state)
        puts 'killed a zombie'
        @others.delete(c)
      else
        @player.health -= ZOMBIE_BITE
      end
      puts 'being eaten by a zombie'
    }

    replenish_cherries
  end

  def replenish_cherries
    if rand > 0.995 && @cherries.size < 3
      @cherries << Vector[WIDTH * rand, HEIGHT * rand]
    end
  end

  def draw
    draw_background

    @cherries.each { |loc| @cherry.draw(loc.x, loc.y, 0, 0.5, 0.5) }

    @animation.draw(Vector[WIDTH - 32, HEIGHT - 32])

    if (@player.health < 0)
      @lifetime ||= (@elapsed_time/1000).to_i
      @paused = true
      @font.draw('You held out for',
                 WIDTH/2 - 200, HEIGHT/2, Game::Z::UI,
                 2, 2, Gosu::Color.from_hsv(@frames%360, 1, 1))
      @font.draw("#{@lifetime} seconds",
                 WIDTH/2 - 200, HEIGHT/2 + @font.height, Game::Z::UI,
                 2, 2, Gosu::Color.from_hsv(@frames%360, 1, 1))
    end

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
      when Gosu::KbP
        toggle_pause
    end
    @player.button_down(id)
    @osd.button_down(id)
  end

  def button_up(id)
    @player.button_up(id)
    @osd.button_up(id)
  end

  def toggle_pause
    @paused = !@paused
  end

end

$game = Game.new
$game.show

