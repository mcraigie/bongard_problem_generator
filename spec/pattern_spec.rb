# Author::    Max Craigie  (@MaxCraigie)
# Copyright:: Copyright (c) 2017 Max Craigie
# License::   Attribution-NonCommercial 3.0 Australia (CC BY-NC 3.0 AU)

require_relative '../pattern.rb'

describe Bongard::Pattern do
  describe '#extract_parameter' do
    it 'identifies the UP delta string' do
      raw_step = "(U2,?1)"
      expect(Bongard::Pattern.extract_parameter(raw_step, 'U')).to eq('2')
    end

    it 'identifies that no UP delta was specified' do
      raw_step = "(D1,?1)"
      expect(Bongard::Pattern.extract_parameter(raw_step, 'U')).to be_nil
    end

    it 'identifies the DOWN delta string' do
      raw_step = "(U2,D2,?1)"
      expect(Bongard::Pattern.extract_parameter(raw_step, 'D')).to eq('2')
    end

    it 'identifies that no DOWN delta was specified' do
      raw_step = "(L1,?1)"
      expect(Bongard::Pattern.extract_parameter(raw_step, 'D')).to be_nil
    end

    it 'identifies the first matching DOWN delta and ignores the rest' do
      raw_step = "(U2,D2,D7,?1)"
      expect(Bongard::Pattern.extract_parameter(raw_step, 'D')).to eq('2')
    end

    it 'identifies the multi-character DOWN delta string' do
      raw_step = "(U2,D37,?1)"
      expect(Bongard::Pattern.extract_parameter(raw_step, 'D')).to eq('37')
    end

    it 'identifies the LEFT delta string' do
      raw_step = "(L10,U2,D2,?1)"
      expect(Bongard::Pattern.extract_parameter(raw_step, 'L')).to eq('10')
    end

    it 'identifies the RIGHT delta string' do
      raw_step = "(U2,D2,R9,?1)"
      expect(Bongard::Pattern.extract_parameter(raw_step, 'R')).to eq('9')
    end
  end

  describe '#convert_pattern' do
    it 'converts the pattern into a chain of steps' do
      pattern = '(?1)>(R2,?3)>(D1,?7)>(L1,?6)'
      expected_steps = [
        {:up => 0, :down => 0, :left => 0, :right => 0, :test => /^1$/},
        {:up => 0, :down => 0, :left => 0, :right => 2, :test => /^3$/},
        {:up => 0, :down => 1, :left => 0, :right => 0, :test => /^7$/},
        {:up => 0, :down => 0, :left => 1, :right => 0, :test => /^6$/},
      ]
      expect(Bongard::Pattern.new(pattern).steps).to eq(expected_steps)
    end

    it 'converts the pattern into a chain of steps' do
      pattern = '(?10)>(R20,?3)'
      expected_steps = [
        {:up => 0, :down => 0, :left => 0, :right => 0, :test => /^10$/},
        {:up => 0, :down => 0, :left => 0, :right => 20, :test => /^3$/},
      ]
      expect(Bongard::Pattern.new(pattern).steps).to eq(expected_steps)
    end

    it 'handles a wildcard test' do
      pattern = '(?.+)>(R20,?3)'
      expected_steps = [
        {:up => 0, :down => 0, :left => 0, :right => 0, :test => /^.+$/},
        {:up => 0, :down => 0, :left => 0, :right => 20, :test => /^3$/},
      ]
      expect(Bongard::Pattern.new(pattern).steps).to eq(expected_steps)
    end

    it 'handles a negated test' do
      pattern = '(?[^1])>(R20,?3)'
      expected_steps = [
        {:up => 0, :down => 0, :left => 0, :right => 0, :test => /^[^1]$/},
        {:up => 0, :down => 0, :left => 0, :right => 20, :test => /^3$/},
      ]
      expect(Bongard::Pattern.new(pattern).steps).to eq(expected_steps)
    end

    it 'handles multiple deltas in a single step' do
      pattern = '(?1)>(R1,D3,?.+)'
      expected_steps = [
        {:up => 0, :down => 0, :left => 0, :right => 0, :test => /^1$/},
        {:up => 0, :down => 3, :left => 0, :right => 1, :test => /^.+$/},
      ]
      expect(Bongard::Pattern.new(pattern).steps).to eq(expected_steps)
    end
  end
end
