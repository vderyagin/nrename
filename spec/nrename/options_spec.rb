require 'spec_helper'

describe Nrename::Options do
  def parse_options(args)
    Nrename::Options.parse args
  end

  describe 'verbosity' do
    it 'is on by default (when no arguments provided)' do
      parse_options([]).verbose.should be_true
    end

    it 'is off when or "--no-verbose" switch is provided' do
      parse_options(%w[--no-verbose]).verbose.should be_false
    end
  end

  describe 'recursive processing' do
    it 'is off by default' do
      parse_options([]).recursive.should be_false
    end

    it 'is on when "-R" of "--recursive" is provided' do
      %w[-R --recursive].each do |option|
        parse_options([option]).recursive.should be_true
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
        parse_options([arg]).dirs.should include subdir_path
      end
    end

    it 'empty if no arguments provided' do
      parse_options([]).dirs.should be == []
    end

    it 'recursively captures all subdirs when -R option provided' do
      dirs = parse_options(['-R', test_dir]).dirs

      dirs.should include test_dir

      subdirs.each do |subdir|
        dirs.should include File.join(test_dir, subdir)
      end
    end
  end
end
