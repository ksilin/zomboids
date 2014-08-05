require 'rspec'
require 'benchmark'
require_relative '../core_ext'

describe 'Constraining' do

  describe 'integer numbers' do
    it 'should do nothing if number below constraint' do
      expect(1.constrain(2)).to be 1
      expect(-1.constrain(-2)).to be -1
    end

    it 'should do nothing if number and constraint have different leading signs' do
      expect(-3.constrain(2)).to be -3
      expect(3.constrain(-1)).to be 3
    end

    it 'should do constrain positive integer numbers' do
      expect(2.constrain(1)).to be 1
    end

    it 'should do constrain negative integer numbers' do
      expect(-2.constrain(-1)).to be -1
    end
  end

  describe 'integer numbers, float constraints' do

    it 'should do nothing if number below constraint' do
      expect(1.constrain(2.1)).to be 1
      expect(-1.constrain(-2.3)).to be -1
    end

    it 'should do nothing if number and constraint have different leading signs' do
      expect(-3.constrain(2.2)).to be -3
      expect(3.constrain(-1.1)).to be 3
    end

    it 'should do constrain positive integer numbers' do
      expect(2.constrain(1.1)).to be 1.1
    end

    it 'should do constrain negative integer numbers' do
      expect(-2.constrain(-1.1)).to be -1.1
    end

  end

  describe 'float numbers, float constraints' do

    it 'should do nothing if number below constraint' do
      expect((1.2).constrain(2.1)).to be 1.2
      expect((-1.1).constrain(-2.3)).to be -1.1
    end

    it 'should do nothing if number and constraint have different leading signs' do
      expect((-3.5).constrain(2.2)).to be -3.5
      expect((3.3).constrain(-1.1)).to be 3.3
    end

    it 'should do constrain positive integer numbers' do
      expect(2.2.constrain(1.1)).to be 1.1
    end

    it 'should do constrain negative integer numbers' do
      expect(-2.3.constrain(-1.1)).to be -1.1
    end

  end

  describe 'float numbers, integer constraints' do

    it 'should do nothing if number below constraint' do
      expect((1.2).constrain(2)).to be 1.2
      expect((-1.1).constrain(-2)).to be -1.1
    end

    it 'should do nothing if number and constraint have different leading signs' do
      expect((-3.5).constrain(2)).to be -3.5
      expect((3.3).constrain(-1)).to be 3.3
    end

    it 'should do constrain positive integer numbers' do
      expect(2.2.constrain(1)).to be 1
    end

    it 'should do constrain negative integer numbers' do
      expect(-2.3.constrain(-1)).to be -1
    end

  end
end

 # 'x < 0 ? -1 : 1' is faster than 'x/x.abs': 10_000_000
# using abs:     1.550000   0.000000   1.550000 (  1.548747)
# using < 0:     1.190000   0.000000   1.190000 (  1.194042)

# describe 'signum benchmark' do
#   Benchmark.bmbm(12) do |x|
#     x.report('using abs: ') { 10_000_000.times {12345.signum} }
#     x.report('using < 0: ') { 10_000_000.times {12345.signum2} }
#   end
# end
