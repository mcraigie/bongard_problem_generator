class BongardGrid
  attr_reader :size

  def initialize(cell_data, size)
    @size = size
    @cell_data = cell_data
  end

  def size; end

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
