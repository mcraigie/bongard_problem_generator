require './errors.rb'

module Bongard
  class Pattern
    attr_reader :steps

    # TODO: raise error if any steps dont have a test
    # TODO: raise error if any steps (apart from the 1st) dont have
    # at least 1 delta
    # TODO: raise error if 1st step has any deltas
    # TODO: extract pattern conversion code into a new Pattern object
    def initialize(pattern_string)
      @steps = pattern_string.split('>').map do |raw_step|
        {
          up:    Pattern.extract_parameter(raw_step, 'U').to_i || 0,
          down:  Pattern.extract_parameter(raw_step, 'D').to_i || 0,
          left:  Pattern.extract_parameter(raw_step, 'L').to_i || 0,
          right: Pattern.extract_parameter(raw_step, 'R').to_i || 0,
          test:  Regexp.new("^#{Pattern.extract_parameter(raw_step, '\?')}$")
        }
      end
    end

    def self.extract_parameter(raw_step, prefix)
      raw_step.scan(Regexp.new("#{prefix}(.*?)[,\)]")).flatten.first
    end

    def to_s
      @value.to_s
    end
  end
end
