require_relative '../grid.rb'

describe Bongard::Grid do

  describe '#initialize' do
    it 'fails if the cell data does not match the size' do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      expect { Bongard::Grid.new(cells, 4) }.to raise_error CellDataSizeError
    end

    it 'fails if the cell data is incomplete' do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8]]
      expect { Bongard::Grid.new(cells, 3) }.to raise_error CellDataSizeError
    end

    it 'fails if the cell data is incomplete' do
      cells = [[1, 2], [4, 5], [7, 8]]
      expect { Bongard::Grid.new(cells, 3) }.to raise_error CellDataSizeError
    end

    it 'fails if the cell data is incomplete' do
      cells = [[1, 2, 3], [4, 5, 6]]
      expect { Bongard::Grid.new(cells, 3) }.to raise_error CellDataSizeError
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
        9 => 1
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

  describe '#height' do
    it 'is the same as the width' do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      grid = Bongard::Grid.new(cells, 3)
      expect(grid.height).to eq(grid.size)
    end
  end

  describe '#width' do
    it 'is the same as the size' do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      grid = Bongard::Grid.new(cells, 3)
      expect(grid.width).to eq(grid.size)
    end
  end

  describe '#any?' do
    before(:all) do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      @grid = Bongard::Grid.new(cells, 3)
    end

    it 'returns true if any cell matches the block' do
      expect(@grid.any? { |c| c.value == 5 }).to eq(true)
    end

    it 'returns false if no cell matches the block' do
      expect(@grid.any? { |c| c.value == 0 }).to eq(false)
    end
  end

  describe '#all?' do
    before(:all) do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      @grid = Bongard::Grid.new(cells, 3)
    end

    it 'returns true if all cells match the block' do
      expect(@grid.all? { |c| c.value > 0 }).to eq(true)
    end

    it 'returns false if any cell does not match the block' do
      expect(@grid.all? { |c| c.value != 2 }).to eq(false)
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
      expect(find_all_results).to eq([])
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
      expect(@grid.cell_at(1,1).value).to eq(1)
    end

    it 'gets the cell at the specified position' do
      expect(@grid.cell_at(3,3).value).to eq(9)
    end

    it 'returns nil if you specify a cell that does not exist' do
      expect(@grid.cell_at(0,0)).to eq(nil)
    end

    it 'returns nil if you specify a cell that does not exist' do
      expect(@grid.cell_at(0,1)).to eq(nil)
    end

    it 'returns nil if you specify a cell that does not exist' do
      expect(@grid.cell_at(4,0)).to eq(nil)
    end

    it 'returns nil if you specify a cell that does not exist' do
      expect(@grid.cell_at(4,4)).to eq(nil)
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
      expect(@grid.cells_in_row(0)).to eq(nil)
    end

    it 'returns nil if you specify a row that does not exist' do
      expect(@grid.cells_in_row(4)).to eq(nil)
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
      expect(@grid.cells_in_col(0)).to eq(nil)
    end

    it 'returns nil if you specify a col that does not exist' do
      expect(@grid.cells_in_col(4)).to eq(nil)
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

end
