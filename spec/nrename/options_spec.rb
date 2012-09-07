require 'spec_helper'
require 'forwardable'

describe Nrename::Options do
  extend Forwardable

  def_delegator Nrename, :parse_options

  after :each do
    Nrename.options.reset                 # do not leak state
  end

  let(:defaults) { parse_options([]) }

  describe 'verbosity' do
    it 'is on by default' do
      expect(defaults.verbose).to be_true
    end

    it 'is on when "-v" switch is provided' do
      expect(parse_options(%w[-v]).verbose).to be_true
    end

    it 'is on when "--verbose" switch is provided' do
      expect(parse_options(%w[--verbose]).verbose).to be_true
    end

    it 'is off when "--no-verbose" switch is provided' do
      expect(parse_options(%w[--no-verbose]).verbose).to be_false
    end
  end

  describe 'recursive processing' do
    it 'is off by default' do
      expect(defaults.recursive).to be_false
    end

    it 'is on when "-R" switch is provided' do
      expect(parse_options(%w[-R]).recursive).to be_true
    end

    it 'is on when "--recursive" switch is provided' do
      expect(parse_options(%w[--recursive]).recursive).to be_true
    end
  end

  describe 'perform actual renaming' do
    it 'is off by default' do
      expect(defaults.execute).to be_false
    end

    it 'is on when "-X" switch is provided' do
      expect(parse_options(%w[-X]).execute).to be_true
    end

    it 'is on when "--execute" switch is provided' do
      expect(parse_options(%w[--execute]).execute).to be_true
    end
  end

  describe 'regular expression' do
    it 'has a default value' do
      expect(defaults.pattern).to be == /(\d+)/
    end

    it 'can be provided with "--regexp" switch' do
      regexp = parse_options(%w[--regexp _(\d+)_]).pattern
      expect(regexp).to be == /_(\d+)_/
    end
  end

  describe 'leaving numbers only' do
    it 'is off by default' do
      expect(defaults.numbers_only).to be_false
    end

    it 'is on when "-N" switch is provided' do
      expect(parse_options(%w[-N]).numbers_only).to be_true
    end

    it 'is on when "--numbers-only" switch is provided' do
      expect(parse_options(%w[--numbers-only]).numbers_only).to be_true
    end
  end

  describe 'renaming of directories' do
    it 'is off by default' do
      expect(defaults.rename_dirs).to be_false
    end

    it 'is on when "-D" switch is provided' do
      expect(parse_options(%w[-D]).rename_dirs).to be_true
    end

    it 'is on when "--rename-dirs" switch is provided' do
      expect(parse_options(%w[--rename-dirs]).rename_dirs).to be_true
    end
  end

  describe 'renumbering files from scratch' do
    it 'is off by default' do
      expect(defaults.renumber).to be_false
    end

    it 'is on when "--renumber" switch is provided' do
      expect(parse_options(%w[--renumber]).renumber).to be_true
    end
  end

  describe 'directory arguments' do
    let(:test_dir) { File.expand_path 'test ][ directory' }
    let(:subdirs) {  ['aa', 'bb', 'cc', 'foo bar [baz] (quux)'] }

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
      expect(defaults.dirs).to be_empty
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
