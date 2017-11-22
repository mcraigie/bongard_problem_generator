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
      expect(@grid.cell_at(1, 1).value).to eq(1)
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
      expect(grid.center_cell).to eq(nil)
    end
  end

  describe '#extract_parameter' do
    before(:all) do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      @grid = Bongard::Grid.new(cells, 3)
    end

    it 'identifies the UP delta string' do
      raw_step = "(U2,?1)"
      expect(@grid.extract_parameter(raw_step, 'U')).to eq('2')
    end

    it 'identifies that no UP delta was specified' do
      raw_step = "(D1,?1)"
      expect(@grid.extract_parameter(raw_step, 'U')).to eq(nil)
    end

    it 'identifies the DOWN delta string' do
      raw_step = "(U2,D2,?1)"
      expect(@grid.extract_parameter(raw_step, 'D')).to eq('2')
    end

    it 'identifies that no DOWN delta was specified' do
      raw_step = "(L1,?1)"
      expect(@grid.extract_parameter(raw_step, 'D')).to eq(nil)
    end

    it 'identifies the first matching DOWN delta and ignores the rest' do
      raw_step = "(U2,D2,D7,?1)"
      expect(@grid.extract_parameter(raw_step, 'D')).to eq('2')
    end

    it 'identifies the multi-character DOWN delta string' do
      raw_step = "(U2,D37,?1)"
      expect(@grid.extract_parameter(raw_step, 'D')).to eq('37')
    end

    it 'identifies the LEFT delta string' do
      raw_step = "(L10,U2,D2,?1)"
      expect(@grid.extract_parameter(raw_step, 'L')).to eq('10')
    end

    it 'identifies the RIGHT delta string' do
      raw_step = "(U2,D2,R9,?1)"
      expect(@grid.extract_parameter(raw_step, 'R')).to eq('9')
    end
  end

  describe '#convert_pattern' do
    before(:all) do
      cells = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      @grid = Bongard::Grid.new(cells, 3)
    end

    it 'converts the pattern into a chain of steps' do
      pattern = '(?1)>(R2,?3)>(D1,?7)>(L1,?6)'
      expected_steps = [
        {:up=>0, :down=>0, :left=>0, :right=>0, :test=>/[1]/},
        {:up=>0, :down=>0, :left=>0, :right=>2, :test=>/[3]/},
        {:up=>0, :down=>1, :left=>0, :right=>0, :test=>/[7]/},
        {:up=>0, :down=>0, :left=>1, :right=>0, :test=>/[6]/}
      ]
      expect(@grid.convert_pattern(pattern)).to eq(expected_steps)
    end

    it 'converts the pattern into a chain of steps' do
      pattern = '(?10)>(R20,?3)'
      expected_steps = [
        {:up=>0, :down=>0, :left=>0, :right=>0, :test=>/[10]/},
        {:up=>0, :down=>0, :left=>0, :right=>20, :test=>/[3]/}
      ]
      expect(@grid.convert_pattern(pattern)).to eq(expected_steps)
    end

    it 'handles a wildcard test' do
      pattern = '(?.)>(R20,?3)'
      expected_steps = [
        {:up=>0, :down=>0, :left=>0, :right=>0, :test=>/[.]/},
        {:up=>0, :down=>0, :left=>0, :right=>20, :test=>/[3]/}
      ]
      expect(@grid.convert_pattern(pattern)).to eq(expected_steps)
    end

    it 'handles a negated test' do
      pattern = '(?^1)>(R20,?3)'
      expected_steps = [
        {:up=>0, :down=>0, :left=>0, :right=>0, :test=>/[^1]/},
        {:up=>0, :down=>0, :left=>0, :right=>20, :test=>/[3]/}
      ]
      expect(@grid.convert_pattern(pattern)).to eq(expected_steps)
    end

    it 'handles multiple deltas in a single step' do
      pattern = '(?1)>(R1,D3,?.)'
      expected_steps = [
        {:up=>0, :down=>0, :left=>0, :right=>0, :test=>/[1]/},
        {:up=>0, :down=>3, :left=>0, :right=>1, :test=>/[.]/}
      ]
      expect(@grid.convert_pattern(pattern)).to eq(expected_steps)
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
      expect(destination).to eq(nil)
    end

    it 'walks off-grid on the right by 1' do
      starting_cell = @grid.cell_at(4, 2)
      destination = @grid.walk_horizontal(starting_cell, 1)
      expect(destination).to eq(nil)
    end

    it 'walks off-grid from the top by 1' do
      starting_cell = @grid.cell_at(2, 1)
      destination = @grid.walk_vertical(starting_cell, -1)
      expect(destination).to eq(nil)
    end

    it 'walks off-grid from the bottom by 1' do
      starting_cell = @grid.cell_at(2, 4)
      destination = @grid.walk_vertical(starting_cell, 1)
      expect(destination).to eq(nil)
    end

    it 'walks off-grid on the left by 2' do
      starting_cell = @grid.cell_at(1, 1)
      destination = @grid.walk_horizontal(starting_cell, -2)
      expect(destination).to eq(nil)
    end

    it 'walks off-grid on the right by 2' do
      starting_cell = @grid.cell_at(4, 1)
      destination = @grid.walk_horizontal(starting_cell, 2)
      expect(destination).to eq(nil)
    end

    it 'walks off-grid from the top by 2' do
      starting_cell = @grid.cell_at(3, 1)
      destination = @grid.walk_vertical(starting_cell, -2)
      expect(destination).to eq(nil)
    end

    it 'walks off-grid from the bottom by 2' do
      starting_cell = @grid.cell_at(4, 4)
      destination = @grid.walk_vertical(starting_cell, 2)
      expect(destination).to eq(nil)
    end
  end



  # describe '#match?' do
  #   before(:all) do
  #     cells = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]]
  #     @grid = Bongard::Grid.new(cells, 4)
  #   end

  #   it 'returns true if the pattern exists' do
  #     # pattern = '(?1)>(R2,?3)>(D1,?7)>(L1,?6)'
  #     expect(@grid.match?('(?1)>(R2,?3)>(D1,?7)>(L1,?6)')).to eq(true)
  #   end

  #   it 'returns false if the pattern does not exist' do
  #     pattern = '(?1)>(R2,?1)'
  #     expect(@grid.match?(pattern)).to eq(false)
  #   end

  #   it 'returns true if the pattern exists' do
  #     pattern = '(?2)>(R2,?4)'
  #     expect(@grid.match?(pattern)).to eq(true)
  #   end

  #   it 'returns false if the pattern does not exist' do
  #     pattern = '(?2)>(R2,?0)'
  #     expect(@grid.match?(pattern)).to eq(false)
  #   end

  #   it 'returns true if the pattern exists' do
  #     pattern = '(?2)>(D1,?6)'
  #     expect(@grid.match?(pattern)).to eq(true)
  #   end
  # end

end
