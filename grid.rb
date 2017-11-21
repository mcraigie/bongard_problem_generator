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

    def initialize(cell_data, size)
      @size = size

      raise CellDataNilError if contains_nil?(cell_data)
      raise CellDataSizeError unless conforms_to_size?(cell_data)
      raise BelowMinimumSizeError unless @size >= 3

      # intentionally trading memory for convenience
      @rows = cell_data.map { |row| row.map { |e| Cell.new(e) } }
      @cols = @rows.transpose
      @cells = @rows.flatten
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

    def edge_cells; end

    def corner_cells; end

    def corner_cell(corner); end

    def center_cell; end

    def match?(pattern_selector); end

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
