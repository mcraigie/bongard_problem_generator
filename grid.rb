require './errors.rb'
require './cell.rb'
require './pattern.rb'

require 'digest'

module Bongard
  # cell_data comes in like this:
  # [ [1,2,3],
  #   [4,5,6],
  #   [7,8,9] ]

  # cells are 1-indexed and the origin is top left:
  # (1,1) (2,1) (3,1)...
  # (1,2) (2,2) (3,2)...
  # (1,3) (2,3) (3,3)...
  #  ...   ...   ...
  class Grid
    attr_reader :size, :original_cell_data

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

    def edge_cells
      return @edge_cells if @edge_cells
      result =  cells_in_row(1) # top row
      result << cells_in_row(size) # bottom row
      result << cells_in_col(1)[1..-2] # left column (sans corners)
      result << cells_in_col(size)[1..-2] # right column (sans corners)
      @edge_cells = result.flatten
    end

    def corner_cells
      return @corner_cells if @corner_cells
      result = cells_in_row(1).values_at(0, -1)
      result << cells_in_row(size).values_at(0, -1)
      @corner_cells = result.flatten
    end

    def center_cell
      return nil if size.even?
      half_way = (size / 2.0).ceil
      cell_at(half_way, half_way)
    end

    def match?(pattern_string)
      pattern = Bongard::Pattern.new(pattern_string)

      # TODO: make more efficient by ruling out impossible starting cells
      each do |starting_cell|
        current_cell = starting_cell
        pattern_found = true

        pattern.steps.each do |step|
          current_cell = relative_cell(current_cell, step)

          unless current_cell && current_cell.match(step[:test])
            pattern_found = false
            break
          end
        end

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

    # TODO: add testing/exceptions for arguments
    def rotate(direction = :clockwise, n = 1)
      cell_data = original_cell_data

      n.times do
        if direction == :clockwise
          cell_data = cell_data.transpose.map(&:reverse)
        elsif direction == :anticlockwise
          cell_data = cell_data.map(&:reverse).transpose
        end
      end

      Bongard::Grid.new(cell_data, size)
    end

    # TODO: add testing/exceptions for arguments
    def mirror(axis)
      if axis == :vertical
        cell_data = original_cell_data.reverse
      elsif axis == :horizontal
        cell_data = original_cell_data.transpose.reverse.transpose
      end

      Bongard::Grid.new(cell_data, size)
    end

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
