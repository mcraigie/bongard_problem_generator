class BongardGrid
  attr_reader :size

  def initialize(cell_data, size)
    @size = size
    @cell_data = cell_data

    raise "bad data" unless cell_data_conforms_to_size?
    raise "bad data" if cell_data_contains_nil?
  end

  def cell_data_conforms_to_size?
    return false if @cell_data.length != @size
    return false unless @cell_data.all? { |row| row.length == @size }
  end

  def cell_data_contains_nil?
    return true if @cell_data.any? { |row| row.nil? || row.any? { |e| e.nil? } }
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
