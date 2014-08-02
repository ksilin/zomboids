class Numeric

  def signum
    self/self.abs
  end

  def constrain(max)

    return self if (max.signum != self.signum)

    op = (max < 0) ? :max : :min
    [self, max].send(op)
  end

  # def constrain!(max)
  #   self = constrain(max)
  # end

end

# puts 17.constrain(5)
# puts 1.constrain(5)
# puts -3.constrain(5)

# puts -3.constrain(-5)
# puts -37.constrain(-5)