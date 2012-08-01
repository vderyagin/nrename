require 'spec_helper'

describe Nrename::Options do
  def parse_options(args)
    Nrename::Options.parse args
  end

  describe 'verbosity' do
    it 'is on by default (when no arguments provided)' do
      expect(parse_options []).to be_verbose
    end

    it 'is off when or "--no-verbose" switch is provided' do
      expect(parse_options %w[--no-verbose]).not_to be_verbose
    end
  end

  describe 'recursive processing' do
    it 'is off by default' do
      expect(parse_options []).not_to be_recursive
    end

    it 'is on when "-R" of "--recursive" is provided' do
      %w[-R --recursive].each do |option|
        expect(parse_options [option]).to be_recursive
      end
    end
  end

  describe 'directory arguments' do
    let(:test_dir) { File.expand_path 'test_dir' }
    let(:subdirs) { %w[aa bb cc] }

    before :all do
      inside test_dir do
        mkdir subdirs
      end
    end

    after :all do
      rm_rf test_dir
    end

    it 'captures rest of arguments as directories to process' do
      subdirs.each do |subdir|
        subdir_path =  File.expand_path subdir, test_dir
        arg = File.join test_dir, subdir
        expect(parse_options([arg]).dirs).to include subdir_path
      end
    end

    it 'empty if no arguments provided' do
      expect(parse_options([]).dirs).to be_empty
    end

    it 'recursively captures all subdirs when -R option provided' do
      dirs = parse_options(['-R', test_dir]).dirs

      expect(dirs).to include test_dir

      subdirs.each do |subdir|
        expect(dirs).to include File.join(test_dir, subdir)
      end
    end
  end
end
