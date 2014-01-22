class Integer
  def prime?
    return false if self < 2
    2.upto(pred).all? { |divisor| remainder(divisor).nonzero? }
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
    abs.to_s.chars.map { |number| number.to_i }
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
    common = [length, other.length].min
    excess = self[common...length] + other[common...other.length]
    self[0...common].zip(other[0...common]).flatten(1) + excess
  end
end