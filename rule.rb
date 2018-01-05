# Author::    Max Craigie  (@MaxCraigie)
# Copyright:: Copyright (c) 2017 Max Craigie
# License::   Attribution-NonCommercial 3.0 Australia (CC BY-NC 3.0 AU)

require './errors.rb'
require './grid.rb'

module Bongard
  class Rule
    attr_reader :description
    def initialize(description, &block)
      raise RuleError unless block_given?
      @rule_proc = block
      @description = description
    end

    def follower?(grid)
      @rule_proc.call(grid)
    end

    def rogue?(grid)
      !follower?(grid)
    end
  end
end
