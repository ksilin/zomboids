class Numeric

  def signum
    self/self.abs
  end

  # does not work right for floats
  def constrain(max)

    return self if (max.signum != self.signum)

    op = (max < 0) ? :max : :min
    [self, max].send(op)
  end

  # def constrain!(max)
  #   self = constrain(max)
  # end
end

require 'matrix'

class Vector
  def x
    self[0]
  end

  def x=(new_x)
    self[0] = new_x
  end

  def y
    self[1]
  end

  def y=(new_y)
    self[1] = new_y
  end


end

# puts 17.constrain(5)
# puts 1.constrain(5)
# puts -3.constrain(5)

# puts -3.constrain(-5)
# puts -37.constrain(-5)