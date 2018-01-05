# Author::    Max Craigie  (@MaxCraigie)
# Copyright:: Copyright (c) 2017 Max Craigie
# License::   Attribution-NonCommercial 3.0 Australia (CC BY-NC 3.0 AU)

require './grid.rb'
require './rule.rb'
require 'set'
require 'digest'
require 'json'
require 'fileutils'

def wrap_grid(grid)
  {
    id: Digest::MD5.hexdigest(grid.to_s),
    specification: grid.to_a
  }
end

def convert_rule_to_problem(rule, other_rules)
  puts "Finding diagrams for: #{rule.description}"
  followers = Set.new
  rogues = Set.new
  correct_answer = nil
  incorrect_answers = Set.new

  loop do
    grid = Bongard::Grid.random
    grid_follows_rule = rule.follower?(grid)

    # TODO: refactor this using send
    if grid_follows_rule
      followers = followers.to_a.sample(5).to_set if followers.length > 5
      followers.add(grid)
    else
      rogues = rogues.to_a.sample(5).to_set if rogues.length > 5
      rogues.add(grid)
    end

    next unless followers.length == 6 && rogues.length == 6

    non_covered_overlapping_rules = other_rules.find_all do |r|
      followers.all? { |g| r.follower?(g) } && rogues.none? { |g| r.follower?(g) }
    end.map(&:description)

    break if non_covered_overlapping_rules.empty?
    puts "Conflict found with #{non_covered_overlapping_rules}. Retrying."
  end

  loop do
    grid = Bongard::Grid.random

    if rule.follower?(grid)
      correct_answer = grid
    else
      incorrect_answers.add(grid)
      incorrect_answers = incorrect_answers.to_a.last(2).to_set
    end

    if !correct_answer.nil? &&
       incorrect_answers.length == 2 &&
       !followers.include?(correct_answer) &&
       !rogues.intersect?(incorrect_answers)
      break
    end
  end

  correct_answer_id = wrap_grid(correct_answer)[:id]

  answers = []
  answers << correct_answer
  answers += incorrect_answers.to_a

  {
    id: Digest::MD5.hexdigest(rule.description),
    rule: rule.description,
    correctAnswerId: correct_answer_id,
    followers: followers.map { |g| wrap_grid(g) },
    rogues: rogues.map { |g| wrap_grid(g) },
    answers: answers.shuffle.map { |g| wrap_grid(g) }
  }
end

# COMPILE A LIST OF ALL RULES
rules = []

Bongard::Grid.each_variety do |v|
  # rows and columns
  (0..3).each do |n|
    Bongard::Grid.each_col do |col|
      rules << Bongard::Rule.new("#{n} of variety #{v} @ col #{col}") do |g|
        g.cells_in_col(col).count { |c| c.is(v) } == n
      end
    end

    Bongard::Grid.each_row do |row|
      rules << Bongard::Rule.new("#{n} of variety #{v} @ row #{row}") do |g|
        g.cells_in_row(row).count { |c| c.is(v) } == n
      end
    end
  end

  # any cells
  Bongard::Grid.each_coord do |c|
    rules << Bongard::Rule.new("variety #{v} @ #{c}") do |g|
      g.cell_at(*c).is(v)
    end
  end

  (0..4).each do |n|
    rules << Bongard::Rule.new("#{n} of variety #{v} in any cell") do |g|
      g.count { |c| c.is(v) } == n
    end
  end

  rules << Bongard::Rule.new("any of variety #{v} @ any cell") do |g|
    g.any? { |c| c.is(v) }
  end

  # corner cells
  (0..4).each do |n|
    rules << Bongard::Rule.new("#{n} of variety #{v} in corner cells") do |g|
      g.corner_cells.count { |c| c.is(v) } == n
    end
  end

  rules << Bongard::Rule.new("variety #{v} @ any corner cell") do |g|
    g.corner_cells.any? { |c| c.is(v) }
  end

  # edge cells
  (5..7).each do |n|
    rules << Bongard::Rule.new("#{n} of variety #{v} in edge cells") do |g|
      g.edge_cells.count { |c| c.is(v) } == n
    end
  end

  rules << Bongard::Rule.new("any of variety #{v} in edge cells") do |g|
    g.edge_cells.any? { |c| c.is(v) }
  end
end

# mirrored (TODO: add diagnonal mirroring)
%i[vertical horizontal].each do |axis|
  rules << Bongard::Rule.new("mirrored #{axis}") { |g| g.mirror(axis) == g }
end

# rotated
(1..2).each do |n|
  rules << Bongard::Rule.new("rotated clockwise # #{n}") do |g|
    g.rotate(:clockwise, n) == g
  end
end

problem_set = rules.map do |rule|
  convert_rule_to_problem(rule, rules - [rule])
end

problem_set.shuffle!

FileUtils.rm_rf(Dir.glob('./json/*'))

problem_set.each_cons(2) do |problem, next_problem|
  problem[:nextProblemId] = next_problem[:id]
  File.write("./json/#{problem[:id]}.json", problem.to_json)
end

puts "#{problem_set.length} problems"
puts "start: #{problem_set.first[:id]}"
