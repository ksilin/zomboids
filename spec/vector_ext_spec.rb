require 'rspec'
require 'benchmark'
require_relative '../core_ext'

describe 'Constraining' do

  describe 'integer numbers' do
    it 'should do nothing if number below constraint' do
      v = Vector[0, 0]
      v.constrain(1)
      expect(v.r).to eq 0
    end

    it 'should do nothing if number equals constraint' do
      [Vector[1, 0], Vector[0, 1], Vector[-1, 0], Vector[0, -1]].each { |v|
        v.constrain(1)
        expect(v.r).to eq 1
      }
    end

    it 'should apply constraint' do
      [Vector[1, 1], Vector[-1, -1]].each { |v|
        constrained = v.constrain(1)
        expect(constrained.r).to be_within(Float::EPSILON).of(1)
      }
    end


  end

end
