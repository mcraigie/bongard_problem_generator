require './errors.rb'
require './cell.rb'

module Bongard

  # cell_data comes in like this:
  # [ [1,2,3],
  #   [4,5,6],
  #   [7,8,9] ]

  # cells at 1-indexed and the origin is top left
  # e.g.
  # (1,1) (2,1) (3,1)
  # (1,2) (2,2) (3,2)
  # (1,3) (2,3) (3,3)

  class Grid
    attr_reader :size
    attr_reader :edge_cells
    attr_reader :corner_cells

    def initialize(cell_data, size)
      @size = size

      raise CellDataNilError if contains_nil?(cell_data)
      raise CellDataSizeError unless conforms_to_size?(cell_data)
      raise BelowMinimumSizeError unless @size >= 3

      # intentionally trading memory for convenience and increased
      # performance when the grid may be accessed many times
      @rows = cell_data.map { |row| row.map { |e| Cell.new(e) } }
      @cols = @rows.transpose
      @cells = @rows.flatten
      @edge_cells = calculate_edge_cells
      @corner_cells = calculate_corner_cells

      prime_cell_neighbours
    end

    def conforms_to_size?(cell_data)
      return false if cell_data.length != @size
      return false unless cell_data.all? { |row| row.length == @size }
      return true
    end

    def contains_nil?(cell_data)
      return true if cell_data.any? { |row| row.nil? || row.any? { |e| e.nil? } }
      return false
    end

    def prime_cell_neighbours
      (1..size).each do |col_id|
        (1..size).each do |row_id|
          current_cell = cell_at(col_id, row_id)

          current_cell.up    = cell_at(col_id,     row_id - 1)
          current_cell.down  = cell_at(col_id,     row_id + 1)
          current_cell.left  = cell_at(col_id - 1, row_id)
          current_cell.right = cell_at(col_id + 1, row_id)
        end
      end
    end

    def each(&block)
      @cells.each &block
    end

    def any?(&block)
      @cells.any? &block
    end

    def all?(&block)
      @cells.all? &block
    end

    def find_all(&block)
      @cells.find_all &block
    end

    def count(&block)
      @cells.count &block
    end

    # 1-indexed
    def cell_at(col_id, row_id)
      return nil unless col_id.between?(1, size) && row_id.between?(1, size)
      @cols[col_id - 1][row_id - 1]
    end

    # 1-indexed
    def cells_in_row(row_id)
      return nil unless row_id.between?(1, size)
      @rows[row_id - 1]
    end

    # 1-indexed
    def cells_in_col(col_id)
      return nil unless col_id.between?(1, size)
      @cols[col_id - 1]
    end

    def calculate_edge_cells
      result = []
      result << cells_in_row(1) # top row
      result << cells_in_row(size) # bottom row
      result << cells_in_col(1)[1..-2] # left column (minus corners)
      result << cells_in_col(size)[1..-2] # right column (minus corners)
      result.flatten
    end

    def calculate_corner_cells
      result = []
      result << cells_in_row(1).values_at(0,-1)
      result << cells_in_row(size).values_at(0,-1)
      result.flatten
    end

    def center_cell
      return nil if size.even?
      half_way = (size / 2.0).ceil
      cell_at(half_way, half_way)
    end

    def match?(pattern)
      steps = convert_pattern(pattern)

      # currently check every cell
      # could make more efficient by analysing the pattern and ruling out
      # sections of the grid that couldn't possibly start a match
      self.each do |starting_cell|
        current_cell = starting_cell
        pattern_found = true

        steps.each do |step|
          current_cell = relative_cell(current_cell, step)

          unless current_cell && current_cell.match(step[:test])
            pattern_found = false
            break
          end
        end

        # exit as soon as possible if the pattern is found
        return true if pattern_found
      end

      return false
    end

    def relative_cell(starting_cell, delta)
      return nil unless starting_cell

      current_cell = starting_cell

      horz_diff = delta[:right] - delta[:left]
      vert_diff = delta[:down] - delta[:up]

      current_cell = walk_horizontal(current_cell, horz_diff)
      current_cell = walk_vertical(current_cell, vert_diff)

      return current_cell
    end

    def walk_dir(starting_cell, diff, negative_dir, positive_dir)
      current_cell = starting_cell

      if diff > 0
        direction = positive_dir
      elsif diff < 0
        diff *= -1
        direction = negative_dir
      end

      diff.times do
        current_cell = current_cell.__send__(direction)
        return nil if current_cell.nil?
      end

      return current_cell
    end

    def walk_horizontal(starting_cell, diff)
      walk_dir(starting_cell, diff, :left, :right)
    end

    def walk_vertical(starting_cell, diff)
      walk_dir(starting_cell, diff, :up, :down)
    end

    def convert_pattern(pattern)
      steps = []
      raw_steps = pattern.split('>')

      steps = raw_steps.map do |raw_step|
        {
          up:    extract_parameter(raw_step, 'U').to_i || 0, 
          down:  extract_parameter(raw_step, 'D').to_i || 0, 
          left:  extract_parameter(raw_step, 'L').to_i || 0, 
          right: extract_parameter(raw_step, 'R').to_i || 0, 
          test:  Regexp.new("^[#{extract_parameter(raw_step, '\?')}]$")
        }
      end

      #raise error if any steps dont have a test
      #raise error if any steps (apart from the 1st) dont have at least 1 delta
      #raise error if 1st step has any deltas
    end

    def extract_parameter(raw_step, prefix)
      raw_step.scan(Regexp.new("#{prefix}(.*?)[,\)]")).flatten.first
    end

    def rotate(n); end

    def mirror(axis); end

    def to_s; end

    def to_json; end

    def hash; end

    def ==(); end
  end
end
