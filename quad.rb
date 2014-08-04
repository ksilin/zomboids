class Quad

  def initialize(size, color)
    @size = size
    @color = color
  end

  def left(loc)
    loc.x
  end

  def right(loc)
    loc.x + @size
  end

  def top(loc)
    loc.y
  end

  def bottom(loc)
    loc.y + @size
  end

  def draw(window, loc)
    window.draw_quad(
        left(loc), top(loc),  @color,
        right(loc), top(loc), @color,
        right(loc), bottom(loc), @color,
        left(loc), bottom(loc), @color)
  end

end