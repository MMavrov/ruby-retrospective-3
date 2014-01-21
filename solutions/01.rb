class Integer
  def prime?
    if self > 0 and (2...self).find { |elem| self % elem == 0 } == nil
      true
    else
      false
    end
  end

  def prime_factors
    return if self == 1
    value = self < 0 ? -self : self
    lpf = (2..value).find { |elem| elem.prime? and value % elem == 0 }
    [lpf, (value/lpf).prime_factors].compact.flatten
  end

  def harmonic
    return if self <= 0
    sum = 0
    (1..self).each { |elem| sum += elem.reciprocal }
    sum
  end

  def reciprocal
    Rational(1, self)
  end

  def digits
    return if self == 0
    value = self < 0 ? -self : self
    [(value/10).digits, value % 10].flatten.compact
  end
end

class Array
  def frequencies
    result = {}
    self.each { |x| result.key?(x) ? result[x] += 1 : result[x] = 1 }
    result
  end

  def average
    sum = 0.0
    self.each { |x| sum += x }
    sum/self.size
  end

  def drop_every(n)
    result = []
    (1..self.size).each { |i| result << self[i-1] if i % n != 0 }
    result
  end

  def combine_with(other)
    result = []
    size = other.size < self.size ? self.size : other.size
    (0...size).each { |idx| result << self[idx] << other[idx] }
    result.compact
  end
end