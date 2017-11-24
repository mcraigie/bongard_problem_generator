# Author::    Max Craigie  (@MaxCraigie)
# Copyright:: Copyright (c) 2017 Max Craigie
# License::   Attribution-NonCommercial 3.0 Australia (CC BY-NC 3.0 AU)

class CellDataSizeError < StandardError
  def initialize(msg = 'Cell data does not conform to specified size')
    super(msg)
  end
end

class BelowMinimumSizeError < StandardError
  def initialize(msg = 'Size must be >= 3')
    super(msg)
  end
end

class CellDataNilError < StandardError
  def initialize(msg = 'Cell data contains nil')
    super(msg)
  end
end
