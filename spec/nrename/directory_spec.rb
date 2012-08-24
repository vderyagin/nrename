require 'spec_helper'

describe Nrename::Directory do
  let(:test_dir) { '/tmp/test_dir' }

  after :each do
    rm_rf test_dir
  end

  describe '#files' do
    it 'returns all files inside directory' do
      files = %w[1.rb 2.rb 3.rb foo.rb bar baz.java]

      inside test_dir do
        touch files
      end

      dir = Nrename::Directory.new test_dir
      expect(dir).to have(files.length).files
    end

    it 'ignores directories' do
      files = %w[1.rb 2.rb 3.rb foo.rb bar baz.java]
      dirs = %w[1 2 03 40 55]

      inside test_dir do
        touch files
        mkdir dirs
      end

      dir = Nrename::Directory.new test_dir
      expect(dir).to have(files.length).files
    end
  end

  describe '#numbered_files' do
    it 'returns all numbered files' do
      files = %w[1.rb 2.rb 3.rb]

      inside test_dir do
        touch files
      end

      dir = Nrename::Directory.new test_dir
      expect(dir).to have(files.length).numbered_files
    end

    it 'returns empty array when there is no num. files in dir' do
      mkdir test_dir
      dir = Nrename::Directory.new test_dir
      expect(dir).to have(:no).numbered_files
    end

    it 'does not care about non-numbered files' do
      numbered_files = %w[1.rb 2.rb 3.rb]
      unnumbered_files = %w[foo.rb bar baz.java]

      inside test_dir do
        touch numbered_files
        touch unnumbered_files
      end

      dir = Nrename::Directory.new test_dir
      expect(dir).to have(numbered_files.length).numbered_files
    end

    it 'does not care about directories' do
      files = %w[1.rb 2.rb 3.rb]
      dirs = %w[1 2 03 40 55]

      inside test_dir do
        touch files
        mkdir dirs
      end

      dir = Nrename::Directory.new test_dir
      expect(dir).to have(files.length).numbered_files
    end
  end

  describe '#field_length' do
    it 'returns minimal number of digits to fit num of any file' do
      inside test_dir do
        touch %w[1 2 3 444 3234 5 6 7]
      end

      dir = Nrename::Directory.new test_dir
      expect(dir.num_field_length).to be == 4
    end

    it 'ignores starting zeros in number' do
      inside test_dir do
        touch %w[001 002 004 035]
      end

      dir = Nrename::Directory.new test_dir
      expect(dir.num_field_length).to be == 2
    end
  end

  describe '#max_number' do
    it 'returns maximum number for all file names' do
      inside test_dir do
        touch %w[1 2 3]
      end

      dir = Nrename::Directory.new test_dir
      expect(dir.max_number).to be == 3
    end

    it 'is not fooled by fancy file names' do
      inside test_dir do
        touch %w[001 foo003bar.java o98.c 30_999.rb]
      end

      dir = Nrename::Directory.new test_dir
      expect(dir.max_number).to be == 98
    end
  end

  describe '#normalize' do
    before do
      Nrename.options.stub :execute => true, :verbose => false
    end

    it 'renames files so than they can be sorted properly' do
      inside test_dir do
        touch %w[1 2 3 10 11 004 005 006]
      end

      dir = Nrename::Directory.new test_dir
      dir.normalize

      expected = %w[01 02 03 04 05 06 10 11]
      renamed_files = Dir.entries(test_dir).
        reject &(File.method :directory?)

      expect(renamed_files).to match_array expected
    end
  end
end
