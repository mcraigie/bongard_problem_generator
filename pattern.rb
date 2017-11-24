# Author::    Max Craigie  (@MaxCraigie)
# Copyright:: Copyright (c) 2017 Max Craigie
# License::   Attribution-NonCommercial 3.0 Australia (CC BY-NC 3.0 AU)

require './errors.rb'

# A Pattern selector is a string containing a series of ">" delimited steps
# e.g.
# '(?1)>(R2,?3)>(D1,?7)>(L1,?6)'
# '(?10)>(R20,?3)'
# '(?.+)>(R20,?3)'
# '(?[^1])>(R20,?3)'
# '(?1)>(R1,D3,?.+)'

# Steps are composed of a series of comma delimited parameters
# (<parameter>,...)

# Parameters are composed of a prefix and value
# <prefix><value>

# Movement parameters are composed of a direction prefix and a distance value
# <direction><distance>
# The <direction> prefix is one of U, D, L, R
# The <distance> value is how many cells to travel in that direction

# Test parameters are composed of the prefix "?" and a test value
# The test value is converted into a regex
# ?<test>
# The <test> value must match the entire cell value
# e.g. (/^<test>$/)

# <test> examples:
# match a specific value: ?1, ?42
# match anything but a specific single digit value: ?[^1]
# match anything but a specific multiple digit value: (?!.*42).*, (?!.*123).* 
# match any value: ?.+ (not sure how useful this is)

# The first step in a pattern must only contain a test parameter
# (and no movement parameters)
# "(?<test>)>..."

# After the first step, all subsequent steps must contain one or more
# movement parameters
# e.g. "(?<first test>)>(U1,R3,?<second test>)>..."

# Do not put conflicting movement parameters in a step
# e.g. (U10,D4,?<some test>)

module Bongard
  # This class converts a pattern selector string into a series of steps that
  # can be used to determine the presence of the pattern within a grid of cells
  class Pattern
    attr_reader :steps

    # Initializes the Pattern by converting the pattern selector into steps
    # Params:
    # +pattern_selector_string+:: the pattern selector to be converted
    def initialize(pattern_selector_string)
      @steps = pattern_selector_string.split('>').map do |raw_step|
        {
          up:    Pattern.extract_parameter(raw_step, 'U').to_i || 0,
          down:  Pattern.extract_parameter(raw_step, 'D').to_i || 0,
          left:  Pattern.extract_parameter(raw_step, 'L').to_i || 0,
          right: Pattern.extract_parameter(raw_step, 'R').to_i || 0,
          test:  Regexp.new("^#{Pattern.extract_parameter(raw_step, '\?')}$")
        }
      end
    end

    # Extracts the value of a parameter from a step string when given the prefix
    # Returns nil if the parameter is not present
    # Params:
    # +raw_step+:: the step as a string
    # +prefix+:: the prefix of the parameter value to be extracted
    def self.extract_parameter(raw_step, prefix)
      raw_step.scan(Regexp.new("#{prefix}(.*?)[,\)]")).flatten.first
    end

    def to_s
      @steps.to_s
    end
  end
end
