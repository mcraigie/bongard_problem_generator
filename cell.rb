# Author::    Max Craigie  (@MaxCraigie)
# Copyright:: Copyright (c) 2017 Max Craigie
# License::   Attribution-NonCommercial 3.0 Australia (CC BY-NC 3.0 AU)

module Bongard
  class Cell
    attr_reader :value
    attr_accessor :up, :down, :left, :right

    def initialize(value)
      @value = value
    end

    def match(regex)
      @value.to_s.match(regex)
    end

    def to_s
      @value.to_s
    end

    def ==(other)
      other.class == this.class && @value == other.value
    end
  end
end
