require 'spec_helper'

describe Nrename::Directory do
  let(:test_dir) { '/tmp/test_dir' }

  after :each do
    rm_rf test_dir
  end

  describe '#numbered_files' do
    it 'correctly determines number of numbered files' do
      inside test_dir do
        touch %w[1.rb 2.rb 3.rb]
      end

      dir = Nrename::Directory.new test_dir
      dir.should have(3).numbered_files
    end

    it 'returns empty array when there is no num. files in dir' do
      mkdir test_dir
      dir = Nrename::Directory.new test_dir
      dir.should have(:no).numbered_files
    end

    it 'does not care about non-numbered files' do
      inside test_dir do
        touch %w[1.rb 2.rb 3.rb foo.rb bar baz.java]
      end

      dir = Nrename::Directory.new test_dir
      dir.should have(3).numbered_files
    end

    it 'does not care about directories' do
      inside test_dir do
        touch %w[1.rb 2.rb 3.rb]
        mkdir %w[1 2 03 40 55]
      end

      dir = Nrename::Directory.new test_dir
      dir.should have(3).numbered_files
    end
  end

  describe '#field_length' do
    it 'returns minimal number of digits to fit num of any file' do
      inside test_dir do
        touch %w[1 2 3 444 3234 5 6 7]
      end

      dir = Nrename::Directory.new test_dir
      dir.num_field_length.should be == 4
    end

    it 'ignores starting zeros in number' do
      inside test_dir do
        touch %w[001 002 004 035]
      end

      dir = Nrename::Directory.new test_dir
      dir.num_field_length.should be == 2
    end
  end

  describe '#max_number' do
    it 'returns maximum number for all file names' do
      inside test_dir do
        touch %w[1 2 3]
      end

      dir = Nrename::Directory.new test_dir
      dir.max_number.should be == 3
    end

    it 'is not fooled by fancy file names' do
      inside test_dir do
        touch %w[001 foo003bar.java o98.c 30_999.rb]
      end

      dir = Nrename::Directory.new test_dir
      dir.max_number.should be == 98
    end
  end

  describe '#normalize' do
    before do
      Nrename.options.stub execute: true, verbose: false
    end

    it 'renames files so than they can be sorted properly' do
      inside test_dir do
        touch %w[1 2 3 10 11 004 005 006]
      end

      dir = Nrename::Directory.new test_dir
      dir.normalize

      expected = %w[01 02 03 04 05 06 10 11]
      renamed_files = Dir.entries(test_dir)
      expected.each { |file| renamed_files.should include file }
    end
  end

  describe '#normalized_name_for' do
    it 'returns normalized name for file' do
      dir = Nrename::Directory.new test_dir
      file = Pathname.new(test_dir) + 'b1.txt'
      dir.stub num_field_length: 4
      new_name = dir.normalized_name_for(file).basename.to_s
      new_name.should be == 'b0001.txt'
    end

    it 'returns bare number if numbers_only options is provided' do
      Nrename.options.stub numbers_only: true
      dir = Nrename::Directory.new test_dir
      file = Pathname.new(test_dir) + 'b1.txt'
      dir.stub num_field_length: 4
      new_name = dir.normalized_name_for(file).basename.to_s
      new_name.should be == '0001.txt'
    end
  end

  describe '#number_for' do
    it 'returns number for file' do
      inside test_dir do
        touch 'av023cd.txt'
      end

      dir = Nrename::Directory.new test_dir
      file = dir.numbered_files.first
      dir.number_for(file).should be == 23
    end
  end

  describe '#adjusted_number_string_for' do
    it 'returns number string adjusted to field length' do
      inside test_dir do
        touch 'qwe0032rty.gif'
      end

      dir = Nrename::Directory.new test_dir
      dir.stub num_field_length: 6
      file = dir.numbered_files.first
      dir.adjusted_number_string_for(file).should be == '000032'
    end
  end
end
