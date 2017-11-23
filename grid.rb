require './errors.rb'
require './cell.rb'

require 'digest'

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
    attr_reader :size, :edge_cells, :corner_cells, :original_cell_data

    def initialize(cell_data, size)
      @size = size
      @original_cell_data = cell_data

      raise CellDataNilError if contains_nil?(cell_data)
      raise CellDataSizeError unless conforms_to_size?(cell_data)
      raise BelowMinimumSizeError unless @size >= 3

      # intentionally trading memory for convenience and increased
      # performance when the grid may be accessed many times
      @rows = cell_data.map { |row| row.map { |e| Cell.new(e) } }
      @cols = @rows.transpose
      @cells = @rows.flatten

      # TODO: modify these to be calculated once when first required
      @edge_cells = calculate_edge_cells
      @corner_cells = calculate_corner_cells

      @cells_primed = false
    end

    def conforms_to_size?(cell_data)
      return false if cell_data.length != @size
      return false unless cell_data.all? { |row| row.length == @size }
      true
    end

    def contains_nil?(cell_data)
      return true if cell_data.any? { |row| row.nil? || row.any?(&:nil?) }
      false
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
      @cells_primed = true
    end

    def each(&block)
      @cells.each(&block)
    end

    def any?(&block)
      @cells.any?(&block)
    end

    def all?(&block)
      @cells.all?(&block)
    end

    def find_all(&block)
      @cells.find_all(&block)
    end

    def count(&block)
      @cells.count(&block)
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
      result << cells_in_col(1)[1..-2] # left column (sans corners)
      result << cells_in_col(size)[1..-2] # right column (sans corners)
      result.flatten
    end

    def calculate_corner_cells
      result = cells_in_row(1).values_at(0, -1)
      result << cells_in_row(size).values_at(0, -1)
      result.flatten
    end

    def center_cell
      return nil if size.even?
      half_way = (size / 2.0).ceil
      cell_at(half_way, half_way)
    end

    def match?(pattern)
      steps = convert_pattern(pattern)

      # TODO: make more efficient by ruling out impossible starting cells
      each do |starting_cell|
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

      false
    end

    def relative_cell(starting_cell, delta)
      return nil unless starting_cell

      current_cell = starting_cell

      horz_diff = delta[:right] - delta[:left]
      vert_diff = delta[:down] - delta[:up]

      current_cell = walk_horizontal(current_cell, horz_diff)
      current_cell = walk_vertical(current_cell, vert_diff)

      current_cell
    end

    def walk_dir(starting_cell, diff, negative_dir, positive_dir)
      prime_cell_neighbours unless @cells_primed

      current_cell = starting_cell

      direction = diff > 0 ? positive_dir : negative_dir

      diff.abs.times do
        current_cell = current_cell.__send__(direction)
        return nil if current_cell.nil?
      end

      current_cell
    end

    def walk_horizontal(starting_cell, diff)
      walk_dir(starting_cell, diff, :left, :right)
    end

    def walk_vertical(starting_cell, diff)
      walk_dir(starting_cell, diff, :up, :down)
    end

    # TODO: extract pattern conversion code into a new Pattern object
    def convert_pattern(pattern)
      pattern.split('>').map do |raw_step|
        {
          up:    extract_parameter(raw_step, 'U').to_i || 0,
          down:  extract_parameter(raw_step, 'D').to_i || 0,
          left:  extract_parameter(raw_step, 'L').to_i || 0,
          right: extract_parameter(raw_step, 'R').to_i || 0,
          test:  Regexp.new("^#{extract_parameter(raw_step, '\?')}$")
        }
      end

      # TODO: raise error if any steps dont have a test
      # TODO: raise error if any steps (apart from the 1st) dont have at least 1 delta
      # TODO: raise error if 1st step has any deltas
    end

    def extract_parameter(raw_step, prefix)
      raw_step.scan(Regexp.new("#{prefix}(.*?)[,\)]")).flatten.first
    end

    def rotate(direction = :clockwise, n = 1)
      new_grid = nil

      n.times do
        if direction == :clockwise
          new_grid = Bongard::Grid.new(@original_cell_data.transpose.map(&:reverse), size)
        elsif direction == :anticlockwise
          new_grid = Bongard::Grid.new(@original_cell_data.transpose, size)
        end
      end

      new_grid
    end

    # depending on the axis, create a new grid with the rows or columns reversed
    # :horizontal or :vertical
    def mirror(axis); end

    def to_json
      "{rows:#{original_cell_data}}".gsub(/\s/, '')
    end

    def hash
      Digest::MD5.hexdigest @original_cell_data.join(',')
    end

    def to_s
      "(Size:#{size}, Cells:[#{original_cell_data.join(',')}])"
    end

    def inspect
      @original_cell_data.inspect
    end

    def ==(other)
      @original_cell_data == other.original_cell_data
    end
  end
end
