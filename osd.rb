class OSD

  DEFAULT_FONT_SIZE = 24

  attr_accessor :data, :visible, :location

  def initialize(loc, drawable, font)
    @location = loc
    @drawable = drawable
    @font = font
    @data = {}
    @visible = true
  end

  def draw(window)
    return unless visible

    @drawable.draw(window, @location)
    @data.each_with_index { |(key, value), i|
# adjust to location
      @font.draw("#{key}: #{value}", location.x, location.y + i*20, 0)
    }
  end

  def toggle
    @visible = !@visible
  end

  def button_up(id)
  end


  def button_down(id)
    case id
      when Gosu::KbO
        toggle
    end
  end

end
