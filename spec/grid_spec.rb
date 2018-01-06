# Author::    Max Craigie  (@MaxCraigie)
# Copyright:: Copyright (c) 2017 Max Craigie
# License::   Attribution-NonCommercial 3.0 Australia (CC BY-NC 3.0 AU)

require_relative '../grid.rb'

describe Bongard::Grid do
  describe '#initialize' do
    it 'fails if the cell data does not match the size' do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      expect { Bongard::Grid.new(cells, 4) }.to raise_error CellDataShapeError
    end

    it 'fails if the cell data is incomplete' do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8]]
      expect { Bongard::Grid.new(cells, 3) }.to raise_error CellDataShapeError
    end

    it 'fails if the cell data is incomplete' do
      cells = [[1, 2], [4, 5], [7, 8]]
      expect { Bongard::Grid.new(cells, 3) }.to raise_error CellDataShapeError
    end

    it 'fails if the cell data is incomplete' do
      cells = [[1, 2, 3], [4, 5, 6]]
      expect { Bongard::Grid.new(cells, 3) }.to raise_error CellDataShapeError
    end

    it 'fails if the cell data contains nil' do
      cells = [[1, 2, 3], [4, nil, 6], [7, 8, 9]]
      expect { Bongard::Grid.new(cells, 3) }.to raise_error CellDataNilError
    end

    it 'fails if the cell data contains nil' do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9], nil]
      expect { Bongard::Grid.new(cells, 3) }.to raise_error CellDataNilError
    end

    it 'fails if the cell data contains nil' do
      cells = [nil, [4, 5, 6], [7, 8, 9]]
      expect { Bongard::Grid.new(cells, 3) }.to raise_error CellDataNilError
    end

    it 'fails if the size is less than 3' do
      cells = [[1, 2], [3, 4]]
      expect { Bongard::Grid.new(cells, 2) }.to raise_error BelowMinimumSizeError
    end

    it 'fails if the size is less than 3' do
      cells = [[1]]
      expect { Bongard::Grid.new(cells, 1) }.to raise_error BelowMinimumSizeError
    end
  end

  describe '#each' do
    it 'visits all cells once' do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      grid = Bongard::Grid.new(cells, 3)

      tally = Hash.new(0)

      grid.each do |cell|
        tally[cell.value] += 1
      end

      expect(tally).to eq({
        1 => 1,
        2 => 1,
        3 => 1,
        4 => 1,
        5 => 1,
        6 => 1,
        7 => 1,
        8 => 1,
        9 => 1,
      })
    end
  end

  describe '#size' do
    it 'returns the size' do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      grid = Bongard::Grid.new(cells, 3)
      expect(grid.size).to eq(3)
    end

    it 'returns the size' do
      cells = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
      grid = Bongard::Grid.new(cells, 4)
      expect(grid.size).to eq(4)
    end
  end

  describe '#any?' do
    before(:all) do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      @grid = Bongard::Grid.new(cells, 3)
    end

    it 'returns true if any cell matches the block' do
      expect(@grid.any? { |c| c.value == 5 }).to be true
    end

    it 'returns false if no cell matches the block' do
      expect(@grid.any? { |c| c.value == 0 }).to be false
    end
  end

  describe '#all?' do
    before(:all) do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      @grid = Bongard::Grid.new(cells, 3)
    end

    it 'returns true if all cells match the block' do
      expect(@grid.all? { |c| c.value > 0 }).to be true
    end

    it 'returns false if any cell does not match the block' do
      expect(@grid.all? { |c| c.value != 2 }).to be false
    end
  end

  describe '#find' do
    it 'returns an array of cells that meet the block criteria' do
      cells = [[1, 2, 3], [5, 5, 5], [7, 8, 9]]
      grid = Bongard::Grid.new(cells, 3)
      find_all_results = grid.find_all { |c| c.value == 5 }.map { |c| c.value }
      expect(find_all_results).to eq([5, 5, 5])
    end

    it 'returns an array of cells that meet the block criteria' do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      grid = Bongard::Grid.new(cells, 3)
      find_all_results = grid.find_all { |c| c.value == 0 }.map { |c| c.value }
      expect(find_all_results).to be_empty
    end
  end

  describe '#count' do
    it 'returns the number of cells that meet the block criteria' do
      cells = [[1, 2, 3], [5, 5, 5], [7, 8, 9]]
      grid = Bongard::Grid.new(cells, 3)
      expect(grid.count { |c| c.value == 5 }).to eq(3)
    end

    it 'returns the number of cells that meet the block criteria' do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      grid = Bongard::Grid.new(cells, 3)
      expect(grid.count { |c| c.value == 5 }).to eq(1)
    end
  end

  describe '#cell_at' do
    before(:all) do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      @grid = Bongard::Grid.new(cells, 3)
    end

    it 'gets the cell at the specified position' do
      expect(@grid.cell_at(1, 1).value).to eq(1)
    end

    it 'gets the cell at the specified position' do
      expect(@grid.cell_at(3, 3).value).to eq(9)
    end

    it 'returns nil if you specify a cell that does not exist' do
      expect(@grid.cell_at(0, 0)).to be_nil
    end

    it 'returns nil if you specify a cell that does not exist' do
      expect(@grid.cell_at(0, 1)).to be_nil
    end

    it 'returns nil if you specify a cell that does not exist' do
      expect(@grid.cell_at(4, 0)).to be_nil
    end

    it 'returns nil if you specify a cell that does not exist' do
      expect(@grid.cell_at(4, 4)).to be_nil
    end
  end

  describe '#cells_in_row' do
    before(:all) do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      @grid = Bongard::Grid.new(cells, 3)
    end

    it 'returns an array containing all the cells in the specified row' do
      results = @grid.cells_in_row(1).map { |c| c.value }
      expect(results).to eq([1, 2, 3])
    end

    it 'returns an array containing all the cells in the specified row' do
      results = @grid.cells_in_row(3).map { |c| c.value }
      expect(results).to eq([7, 8, 9])
    end

    it 'returns nil if you specify a row that does not exist' do
      expect(@grid.cells_in_row(0)).to be_nil
    end

    it 'returns nil if you specify a row that does not exist' do
      expect(@grid.cells_in_row(4)).to be_nil
    end
  end

  describe '#cells_in_col' do
    before(:all) do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      @grid = Bongard::Grid.new(cells, 3)
    end

    it 'returns an array containing all the cells in the specified col' do
      results = @grid.cells_in_col(1).map { |c| c.value }
      expect(results).to eq([1, 4, 7])
    end

    it 'returns an array containing all the cells in the specified col' do
      results = @grid.cells_in_col(3).map { |c| c.value }
      expect(results).to eq([3, 6, 9])
    end

    it 'returns nil if you specify a col that does not exist' do
      expect(@grid.cells_in_col(0)).to be_nil
    end

    it 'returns nil if you specify a col that does not exist' do
      expect(@grid.cells_in_col(4)).to be_nil
    end
  end

  describe '#edge_cells' do
    it 'returns an array containing all the cells at the edge' do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      grid = Bongard::Grid.new(cells, 3)
      results = grid.edge_cells.map { |c| c.value }.sort
      expect(results).to eq([1, 2, 3, 4, 6, 7, 8, 9])
    end

    it 'returns an array containing all the cells at the edge' do
      cells = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]]
      grid = Bongard::Grid.new(cells, 4)
      results = grid.edge_cells.map { |c| c.value }.sort
      expect(results).to eq([1, 2, 3, 4, 5, 8, 9, 12, 13, 14, 15, 16])
    end
  end

  describe '#corner_cells' do
    it 'returns an array containing all corner cells' do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      grid = Bongard::Grid.new(cells, 3)
      results = grid.corner_cells.map { |c| c.value }.sort
      expect(results).to eq([1, 3, 7, 9])
    end

    it 'returns an array containing all corner cells' do
      cells = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]]
      grid = Bongard::Grid.new(cells, 4)
      results = grid.corner_cells.map { |c| c.value }.sort
      expect(results).to eq([1, 4, 13, 16])
    end
  end

  describe '#center_cell' do
    it 'returns the center cell if the grid size is odd' do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      grid = Bongard::Grid.new(cells, 3)
      expect(grid.center_cell.value).to eq(5)
    end

    it 'returns nil if the grid size is even' do
      cells = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]]
      grid = Bongard::Grid.new(cells, 4)
      expect(grid.center_cell).to be_nil
    end
  end

  describe '#walk_dir (#walk_horizontal #walk_vertical)' do
    before(:all) do
      cells = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]]
      @grid = Bongard::Grid.new(cells, 4)
    end

    it 'walks left 1' do
      starting_cell = @grid.cell_at(2, 1)
      destination = @grid.walk_horizontal(starting_cell, -1)
      expect(destination.value).to eq(1)
    end

    it 'walks right 1' do
      starting_cell = @grid.cell_at(1, 1)
      destination = @grid.walk_horizontal(starting_cell, 1)
      expect(destination.value).to eq(2)
    end

    it 'walks up 1' do
      starting_cell = @grid.cell_at(2, 2)
      destination = @grid.walk_vertical(starting_cell, -1)
      expect(destination.value).to eq(2)
    end

    it 'walks down 1' do
      starting_cell = @grid.cell_at(3, 3)
      destination = @grid.walk_vertical(starting_cell, 1)
      expect(destination.value).to eq(15)
    end

    it 'walks left 3' do
      starting_cell = @grid.cell_at(4, 1)
      destination = @grid.walk_horizontal(starting_cell, -3)
      expect(destination.value).to eq(1)
    end

    it 'walks right 3' do
      starting_cell = @grid.cell_at(1, 1)
      destination = @grid.walk_horizontal(starting_cell, 3)
      expect(destination.value).to eq(4)
    end

    it 'walks up 3' do
      starting_cell = @grid.cell_at(3, 4)
      destination = @grid.walk_vertical(starting_cell, -3)
      expect(destination.value).to eq(3)
    end

    it 'walks down 3' do
      starting_cell = @grid.cell_at(1, 1)
      destination = @grid.walk_vertical(starting_cell, 3)
      expect(destination.value).to eq(13)
    end

    it 'walks off-grid on the left by 1' do
      starting_cell = @grid.cell_at(1, 1)
      destination = @grid.walk_horizontal(starting_cell, -1)
      expect(destination).to be_nil
    end

    it 'walks off-grid on the right by 1' do
      starting_cell = @grid.cell_at(4, 2)
      destination = @grid.walk_horizontal(starting_cell, 1)
      expect(destination).to be_nil
    end

    it 'walks off-grid from the top by 1' do
      starting_cell = @grid.cell_at(2, 1)
      destination = @grid.walk_vertical(starting_cell, -1)
      expect(destination).to be_nil
    end

    it 'walks off-grid from the bottom by 1' do
      starting_cell = @grid.cell_at(2, 4)
      destination = @grid.walk_vertical(starting_cell, 1)
      expect(destination).to be_nil
    end

    it 'walks off-grid on the left by 2' do
      starting_cell = @grid.cell_at(1, 1)
      destination = @grid.walk_horizontal(starting_cell, -2)
      expect(destination).to be_nil
    end

    it 'walks off-grid on the right by 2' do
      starting_cell = @grid.cell_at(4, 1)
      destination = @grid.walk_horizontal(starting_cell, 2)
      expect(destination).to be_nil
    end

    it 'walks off-grid from the top by 2' do
      starting_cell = @grid.cell_at(3, 1)
      destination = @grid.walk_vertical(starting_cell, -2)
      expect(destination).to be_nil
    end

    it 'walks off-grid from the bottom by 2' do
      starting_cell = @grid.cell_at(4, 4)
      destination = @grid.walk_vertical(starting_cell, 2)
      expect(destination).to be_nil
    end
  end

  describe '#match?' do
    before(:all) do
      cells = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]]
      @grid = Bongard::Grid.new(cells, 4)
    end

    it 'returns true if the pattern exists' do
      expect(@grid.match?('(?1)>(R2,?3)>(D1,?7)>(L1,?6)')).to be true
    end

    it 'returns false if the pattern does not exist' do
      expect(@grid.match?('(?1)>(R2,?1)')).to be false
    end

    it 'returns true if the pattern exists' do
      expect(@grid.match?('(?2)>(R2,?4)')).to be true
    end

    it 'returns false if the pattern does not exist' do
      expect(@grid.match?('(?2)>(R2,?0)')).to be false
    end

    it 'returns true if the pattern exists' do
      expect(@grid.match?('(?2)>(D1,?6)')).to be true
    end
  end

  describe '#==' do
    before(:all) do
      @cells1 = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]]
      @grid1 = Bongard::Grid.new(@cells1, 4)
    end

    it 'is true if the grids have the same values for all cells' do
      same_grid = Bongard::Grid.new(@cells1, 4)
      expect(@grid1).to eq(same_grid)
    end

    it 'is false if the grids do not have the same values for all cells' do
      cells2 = [[1, 5, 9, 13], [2, 6, 10, 14], [3, 7, 11, 15], [4, 8, 12, 16]]
      different_grid = Bongard::Grid.new(cells2, 4)
      expect(@grid1).not_to eq(different_grid)
    end
  end

  # describe '#to_json' do
  #   it 'converts the grid object to JSON' do
  #     cells = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]]
  #     grid = Bongard::Grid.new(cells, 4)
  #     grid_as_json = '[[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]'
  #     expect(grid.to_json).to eq(grid_as_json)
  #   end
  # end

  describe '#rotate' do
    before(:all) do
      cells1 = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]]
      @starting_grid = Bongard::Grid.new(cells1, 4)

      cells2 = [[13, 9, 5, 1], [14, 10, 6, 2], [15, 11, 7, 3], [16, 12, 8, 4]]
      @rotated_right_1 = Bongard::Grid.new(cells2, 4)

      cells3 = [[16, 15, 14, 13], [12, 11, 10, 9], [8, 7, 6, 5], [4, 3, 2, 1]]
      @rotated_right_2 = Bongard::Grid.new(cells3, 4)

      cells4 = [[4, 8, 12, 16], [3, 7, 11, 15], [2, 6, 10, 14], [1, 5, 9, 13]]
      @rotated_right_3 = Bongard::Grid.new(cells4, 4)
    end

    it 'returns a copy of the grid rotated once clockwise' do
      expect(@starting_grid.rotate(:clockwise, 1)).to eq(@rotated_right_1)
    end

    it 'returns a copy of the grid rotated twice clockwise' do
      expect(@starting_grid.rotate(:clockwise, 2)).to eq(@rotated_right_2)
    end

    it 'returns a copy of the grid rotated once anticlockwise' do
      expect(@starting_grid.rotate(:anticlockwise, 1)).to eq(@rotated_right_3)
    end

    it 'returns a copy of the grid rotated twice anticlockwise' do
      expect(@starting_grid.rotate(:anticlockwise, 2)).to eq(@rotated_right_2)
    end
  end

  describe '#mirror' do
    before(:all) do
      cells_1a = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      @grid_1a = Bongard::Grid.new(cells_1a, 3)

      cells_1b = [[7, 8, 9], [4, 5, 6], [1, 2, 3]]
      @grid_1b = Bongard::Grid.new(cells_1b, 3)

      cells_1c = [[3, 2, 1], [6, 5, 4], [9, 8, 7]]
      @grid_1c = Bongard::Grid.new(cells_1c, 3)

      cells_2a = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]]
      @grid_2a = Bongard::Grid.new(cells_2a, 4)

      cells_2b = [[13, 14, 15, 16], [9, 10, 11, 12], [5, 6, 7, 8], [1, 2, 3, 4]]
      @grid_2b = Bongard::Grid.new(cells_2b, 4)

      cells_2c = [[4, 3, 2, 1], [8, 7, 6, 5], [12, 11, 10, 9], [16, 15, 14, 13]]
      @grid_2c = Bongard::Grid.new(cells_2c, 4)
    end

    it 'returns a copy of the grid mirrored vertically' do
      expect(@grid_1a.mirror(:vertical)).to eq(@grid_1b)
    end

    it 'returns a copy of the grid mirrored horizontaly' do
      expect(@grid_1a.mirror(:horizontal)).to eq(@grid_1c)
    end

    it 'returns a copy of the grid mirrored vertically' do
      expect(@grid_2a.mirror(:vertical)).to eq(@grid_2b)
    end

    it 'returns a copy of the grid mirrored horizontaly' do
      expect(@grid_2a.mirror(:horizontal)).to eq(@grid_2c)
    end
  end
end
