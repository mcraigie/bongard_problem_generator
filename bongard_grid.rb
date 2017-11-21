require './errors.rb'
class BongardGrid
  attr_reader :size

  def initialize(cell_data, size)
    @size = size


    raise CellDataNilError if contains_nil?(cell_data)
    raise CellDataSizeError unless conforms_to_size?(cell_data)
    raise BelowMinimumSizeError unless @size >= 3
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

  def each(&block); end

  def any?(&block); end

  def all?(&block); end

  def find(&block); end

  def count(&block); end

  def map(&block); end

  def at_cell(col_id, row_id); end

  def at_row(row_id); end

  def at_col(col_id); end

  def at_edges; end

  def at_corners; end

  def at_center; end

  def match?(pattern_selector); end

  def rotate; end

  def mirror; end

  def to_s; end

  def to_json; end

  def hash; end

  def ==(); end

  alias_method :height, :size
  alias_method :width, :size
end
