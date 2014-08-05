require 'rspec'
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
