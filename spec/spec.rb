require_relative '../bongard_grid.rb'

describe BongardGrid do
  describe '#each' do

    it 'visits all cells once' do
      cell_data = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      grid = BongardGrid.new(cell_data, 3)

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
      cell_data = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      grid = BongardGrid.new(cell_data, 3)
      expect(grid.size).to eq(3)
    end

    it 'returns the size' do
      cell_data = [[0, 0], [0, 0]]
      grid = BongardGrid.new(cell_data, 2)
      expect(grid.size).to eq(2)
    end
  end

  describe '#height' do
    it 'is the same as the width' do
      cell_data = [[0, 0], [0, 0]]
      grid = BongardGrid.new(cell_data, 2)
      expect(grid.height).to eq(grid.size)
    end
  end

  describe '#width' do
    it 'is the same as the size' do
      cell_data = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      grid = BongardGrid.new(cell_data, 3)
      expect(grid.width).to eq(grid.size)
    end
  end

  describe '#initialize' do
    it 'fails if the cell data does not match the size' do
      cell_data = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      expect { BongardGrid.new(cell_data, 4) }.to raise_error
    end

    it 'fails if the cell data is incomplete' do
      cell_data = [[1, 2, 3], [4, 5, 6], [7, 8]]
      expect { BongardGrid.new(cell_data, 3) }.to raise_error
    end

    it 'fails if the cell data is incomplete' do
      cell_data = [[1, 2], [4, 5], [7, 8]]
      expect { BongardGrid.new(cell_data, 3) }.to raise_error
    end

    it 'fails if the cell data is incomplete' do
      cell_data = [[1, 2, 3], [4, 5, 6]]
      expect { BongardGrid.new(cell_data, 3) }.to raise_error
    end

    it 'fails if the cell data contains nil' do
      cell_data = [[1, 2, 3], [4, nil, 6], [7, 8, 9]]
      expect { BongardGrid.new(cell_data, 3) }.to raise_error
    end

    it 'fails if the cell data contains nil' do
      cell_data = [[1, 2, 3], [4, 5, 6], [7, 8, 9], nil]
      expect { BongardGrid.new(cell_data, 3) }.to raise_error
    end

    it 'fails if the cell data contains nil' do
      cell_data = [nil, [4, 5, 6], [7, 8, 9]]
      expect { BongardGrid.new(cell_data, 3) }.to raise_error
    end

    it 'fails if the size is less than 3' do
      cell_data = [[1, 2], [3, 4]]
      expect { BongardGrid.new(cell_data, 2) }.to raise_error
    end

    it 'fails if the size is less than 3' do
      cell_data = [[1]]
      expect { BongardGrid.new(cell_data, 1) }.to raise_error
    end
  end
end
