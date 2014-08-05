class Numeric

  def signum
    self < 0 ? -1 : 1
  end

  def constrain(constraint)

    return self if (constraint.signum != self.signum)

    op = (constraint < 0) ? :max : :min
    [self, constraint].send(op)
  end
end

require 'matrix'

# --- convenience methods - x & y for 2d stuff

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
