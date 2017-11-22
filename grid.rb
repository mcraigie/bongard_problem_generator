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
          cell = cell_at(col_id, row_id)
          cell.up = cell_at(col_id, row_id - 1)
          cell.down = cell_at(col_id, row_id + 1)
          cell.left = cell_at(col_id - 1, row_id)
          cell.right = cell_at(col_id + 1, row_id)
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
      # section of the grid that couldn't possibly start a match
      self.each do |starting_cell|
        current_cell = starting_cell
        pattern_found = true

        steps.each do |step|
          unless current_cell.match(step[:test])
            pattern_found = false
            break
          end

          current_cell = relative_cell(current_cell, step)
        end

        # exit as soon as possible if the pattern is found
        return true if pattern_found
      end

      return false
    end

    def relative_cell(starting_cell, delta)
      current_cell = starting_cell
      row_diff = delta[:left] - delta[:right]
      col_diff = delta[:up] - delta[:down]

      current_cell = walk_row(starting_cell, row_diff)
      current_cell = walk_col(starting_cell, col_diff)

      return current_cell
    end

    def walk_row(starting_cell, row_diff)
      current_cell = starting_cell
      if row_diff > 0
        direction = :left
      elsif row_diff < 0
        row_diff * -1
        direction = :right
      end

      row_diff.times do
        current_cell = current_cell.__send__(direction)
      end

      return current_cell
    end

    def walk_col(starting_cell, col_diff)
      current_cell = starting_cell
      if col_diff > 0
        direction = :up
      elsif col_diff < 0
        col_diff * -1
        direction = :down
      end

      col_diff.times do
        current_cell = current_cell.__send__(direction)
      end

      return current_cell
    end

    def convert_pattern(pattern)
      #raise error if the pattern is crap
      pattern.split('>')
      [
        {
          test: /[1]/,
          left: 0,
          right: 1,
          up: 0,
          down: 1
        },
        {
          test: /[6]/,
          left: 0,
          right: 0,
          up: 0,
          down: 0
        }
      ]
    end

    def rotate(n); end

    def mirror(axis); end

    def to_s; end

    def to_json; end

    def hash; end

    def ==(); end

    alias_method :height, :size
    alias_method :width, :size
  end
end
