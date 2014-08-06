class Quad

  def initialize(size, color, border_color = Gosu::Color::BLACK)
    @size = size
    @color = color
    @border_color = border_color
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

  def draw(window, loc, z = Game::Z::Others, color = @color)
    window.draw_quad(
        left(loc), top(loc),  color,
        right(loc), top(loc), color,
        right(loc), bottom(loc), color,
        left(loc), bottom(loc), color, z)

    window.draw_line(left(loc), top(loc), @border_color,
                     right(loc), top(loc), @border_color, z)

    window.draw_line(right(loc), top(loc), @border_color,
                     right(loc), bottom(loc), @border_color, z)

    window.draw_line(right(loc), bottom(loc), @border_color,
                     left(loc), bottom(loc), @border_color, z)

    window.draw_line(left(loc), top(loc), @border_color,
                     left(loc), bottom(loc), @border_color, z)

  end

end