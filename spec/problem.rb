# Author::    Max Craigie  (@MaxCraigie)
# Copyright:: Copyright (c) 2017 Max Craigie
# License::   Attribution-NonCommercial 3.0 Australia (CC BY-NC 3.0 AU)

require_relative '../problem.rb'

describe Bongard::Problem do
  describe '#initialize' do
    it 'requires a rule' do
      expect { Bongard::Problem.new }.to raise_error
    end
  end
end
