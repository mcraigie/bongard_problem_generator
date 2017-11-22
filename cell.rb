module Bongard
  class Cell
    attr_reader :value
    attr_accessor :up
    attr_accessor :down
    attr_accessor :left
    attr_accessor :right

    def initialize(value)
      @value = value
    end

    def match(regex)
      value.to_s.match(regex)
    end

    def to_s
      value.to_s
    end
  end
end
