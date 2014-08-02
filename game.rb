require 'hasu'

#Hasu.load 'world.rb'

Player = Struct.new(:x, :y, :color) do

  def left;
    x;
  end

  def right;
    x + 20;
  end

  def top;
    y;
  end

  def bottom;
    y + 20;
  end

  def follow(other)
    @vec ||= [0, 0]

    calc_acceleration(other)
    accelerate
    constrain_speed
    move
  end

  def draw(window)
    window.draw_quad(
        left, top, color,
        right, top, color,
        right, bottom, color,
        left, bottom, color)
  end

  def constrain_speed
    sigVecX = (@vec[0]/@vec[0].abs)
    sigVecY = (@vec[1]/@vec[1].abs)

    @vec[0] = sigVecX * [@vec[0].abs, 5].min
    @vec[1] = sigVecY * [@vec[1].abs, 5].min
  end

  def calc_acceleration(other)
    vecX = (other.x - x)
    vecY = (other.y - y)

    dist2 = Math::sqrt(vecX*vecX + vecY*vecY)

    sigX = (vecX/vecX.abs)
    sigY = (vecY/vecY.abs)

    @accX = sigX*[(vecX/dist2).abs, 5].min
    @accY = sigY*[(vecY/dist2).abs, 5].min
  end

  def accelerate
    @vec[0] += @accX
    @vec[1] += @accY
  end

  def move
    self.x += @vec[0]*(0.1 + rand)
    self.y += @vec[1]*(0.1 + rand)
  end
end

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


