require 'spec_helper'

describe Nrename::NumberedFile do
  def numbered_file(path)
    Nrename::NumberedFile.new Pathname.new path
  end

  describe '#number' do
    it 'returns correct number for simple cases' do
      file = numbered_file '123'
      expect(file.number).to be == 123
    end

    it 'returns correct number for cluttered file names' do
      file = numbered_file 'aa_125bb.txt'
      expect(file.number).to be == 125
    end

    it 'handles leading zeros the right way' do
      file = numbered_file '0001.txt'
      expect(file.number).to be == 1
    end

    it 'handles different regular expressions' do
      Nrename.options.stub :pattern => /^foo_0001_(\d+)\.txt$/

      file = numbered_file 'foo_0001_0452.txt'
      expect(file.number).to be == 452
    end
  end

  describe '#normalized_path' do
    context 'leaving numbers only' do
      before do
        Nrename.options.stub :numbers_only => true
      end

      it 'normalizes file name' do
        file = numbered_file 'abc_34.rb'

        file.stub :number_length => 3
        expect(file.normalized_path.to_s).to be == '034.rb'
      end
    end

    context 'replacing numbers' do
      before do
        Nrename.options.stub :numbers_only => false
      end

      it 'normalizes file name' do
        file = numbered_file 'abc_34.rb'

        file.stub :number_length => 5
        expect(file.normalized_path.to_s).to be == 'abc_00034.rb'
      end
    end
  end

  describe '#adjusted_number' do
    it 'returns number, adjusted accordingly to #number_length' do
      file = numbered_file 'foo123bar'

      file.stub :number_length => 4
      expect(file.adjusted_number).to be == '0123'
    end
  end
end
