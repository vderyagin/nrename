require 'spec_helper'

describe Nrename::Utils do
  include Nrename::Utils

  describe '.all_subdirs_of' do
    let(:test_dir) { File.expand_path '[dir] )with( funny {name}' }

    let(:subdirs) {
      %w[foo bar baz quux].map { |dir|
        File.expand_path dir, test_dir
      }
    }

    before :each do
      mkdir_p subdirs
    end

    after :each do
      rm_rf test_dir
    end

    it 'returns subdirectories of provided directory' do
      expect(all_subdirs_of test_dir).to match_array subdirs
    end

    it 'ignores plain files' do
      inside test_dir do
        touch %w[some plain files]
      end

      expect(all_subdirs_of test_dir).to match_array subdirs
    end

    it 'captures deeply nested directories' do
      inside test_dir do
        inside 'deeper' do
          inside 'even_deeper' do
            mkdir 'deepest'
          end
        end
      end

      all_subdirs = [
        File.join(test_dir, 'deeper'),
        File.join(test_dir, 'deeper', 'even_deeper'),
        File.join(test_dir, 'deeper', 'even_deeper', 'deepest')
      ] + subdirs

      expect(all_subdirs_of test_dir).to match_array all_subdirs
    end

    it 'raises error when given argument is not a directory' do
      expect {
        all_subdirs_of '/non/existant/directory'
      }.to raise_error StandardError
    end
  end
end
