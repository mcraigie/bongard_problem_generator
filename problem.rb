# Author::    Max Craigie  (@MaxCraigie)
# Copyright:: Copyright (c) 2017 Max Craigie
# License::   Attribution-NonCommercial 3.0 Australia (CC BY-NC 3.0 AU)

require './errors.rb'
require './rule.rb'
require 'set'
require 'digest'

module Bongard
  class Problem

    def initialize(rule, other_rules, verbose: false)
      @rule = rule

      puts "Finding diagrams for: #{@rule.description}" if verbose
      @followers = Set.new
      @rogues = Set.new
      @correct_answer = nil
      incorrect_answers = Set.new
    
      loop do
        grid = Bongard::Grid.random
        grid_follows_rule = @rule.follower?(grid)
    
        # TODO: refactor this using send
        if grid_follows_rule
          @followers = @followers.to_a.sample(5).to_set if @followers.length > 5
          @followers.add(grid)
        else
          @rogues = @rogues.to_a.sample(5).to_set if @rogues.length > 5
          @rogues.add(grid)
        end
    
        next unless @followers.length == 6 && @rogues.length == 6
    
        non_covered_overlapping_rules = other_rules.find_all do |r|
          @followers.all? { |g| r.follower?(g) } && @rogues.none? { |g| r.follower?(g) }
        end.map(&:description)
    
        break if non_covered_overlapping_rules.empty?
        puts "Conflict found with #{non_covered_overlapping_rules}. Retrying." if verbose
      end
    
      loop do
        grid = Bongard::Grid.random
    
        if @rule.follower?(grid)
          @correct_answer = grid
        else
          incorrect_answers.add(grid)
          incorrect_answers = incorrect_answers.to_a.last(2).to_set
        end
    
        if !@correct_answer.nil? &&
           incorrect_answers.length == 2 &&
           !@followers.include?(@correct_answer) &&
           !@rogues.intersect?(incorrect_answers)
          break
        end
      end

      @answers = [@correct_answer, incorrect_answers.to_a].flatten.shuffle
    end

    def to_h
      {
        id: Digest::MD5.hexdigest(@rule.description),
        rule: @rule.description,
        correctAnswerId: @correct_answer.hexdigest,
        followers: @followers.map(&:to_h),
        rogues: @rogues.map(&:to_h),
        answers: @answers.map(&:to_h),
      }
    end
  end
end
