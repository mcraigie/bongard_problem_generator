# Author::    Max Craigie  (@MaxCraigie)
# Copyright:: Copyright (c) 2017 Max Craigie
# License::   Attribution-NonCommercial 3.0 Australia (CC BY-NC 3.0 AU)

require './grid.rb'
require './problem.rb'
require './rule.rb'
require './rule_set.rb'
require 'json'
require 'fileutils'

rules = Bongard::RuleSet.all

problem_set = rules.map do |rule|
  Bongard::Problem.new(rule, rules - [rule], verbose: true).to_h
end

problem_set.shuffle!

FileUtils.rm_rf(Dir.glob('./json/*'))

problem_set.each do |problem|
  File.write("./json/#{problem[:id]}.json", problem.to_json)
end

puts "#{problem_set.length} problems"
