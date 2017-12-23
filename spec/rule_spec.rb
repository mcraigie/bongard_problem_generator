# Author::    Max Craigie  (@MaxCraigie)
# Copyright:: Copyright (c) 2017 Max Craigie
# License::   Attribution-NonCommercial 3.0 Australia (CC BY-NC 3.0 AU)

require_relative '../rule.rb'

describe Bongard::Rule do
  describe '#initialize' do
    it 'takes a simple block without raising an error' do
      expect { Bongard::Rule.new { |grid| grid.any? { |c| c.value == 5 } } }.not_to raise_error
    end

    it 'to raise an error when not given a block' do
      expect { Bongard::Rule.new() }.to raise_error RuleError
    end
  end

  describe '#follower?' do
    before(:all) do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      @grid = Bongard::Grid.new(cells, 3)
    end

    it 'checks if the given grid follows the rule' do
      rule = Bongard::Rule.new { |grid| grid.any? { |c| c.value == 5 } }
      expect(rule.follower?(@grid)).to be true
    end

    it 'checks if the given grid follows the rule' do
      rule = Bongard::Rule.new { |grid| grid.any? { |c| c.value == 27 } }
      expect(rule.follower?(@grid)).to be false
    end
  end

  describe '#rogue?' do
    before(:all) do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      @grid = Bongard::Grid.new(cells, 3)
    end

    it 'checks if the given grid does not follow the rule' do
      rule = Bongard::Rule.new { |grid| grid.any? { |c| c.value == 5 } }
      expect(rule.rogue?(@grid)).to be false
    end

    it 'checks if the given grid does not follow the rule' do
      rule = Bongard::Rule.new { |grid| grid.any? { |c| c.value == 90 } }
      expect(rule.rogue?(@grid)).to be true
    end
  end

end
