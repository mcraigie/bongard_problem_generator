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
