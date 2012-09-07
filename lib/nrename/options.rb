require 'forwardable'
require 'optparse'
require 'ostruct'
require 'set'
require 'shellwords'
require 'singleton'

module Nrename
  class Options
    include Singleton

    def default_options
      {
        :numbers_only => false,
        :dirs         => Set.new,
        :execute      => false,
        :pattern      => /(\d+)/,
        :recursive    => false,
        :rename_dirs  => false,
        :renumber     => false,
        :verbose      => true
      }
    end

    extend Forwardable
    def_delegators :options, *instance.default_options.keys

    def options
      @options ||= OpenStruct.new default_options
    end

    def reset
      @options = nil
    end

    def parser
      OptionParser.new do |opts|
        opts.banner = "Usage: #{Nrename.executable_name} [OPTINS] DIR..."

        opts.separator ''
        opts.separator 'Options:'

        opts.on '-X', '--execute', "Do actual work" do |x|
          options.execute = x
        end

        opts.on '-R', '--recursive',
        'Process given directories recursively' do |rec|
          options.recursive = rec
        end

        opts.on '-N', '--numbers-only',
        'Leave only numbers in file name' do |n|
          options.numbers_only = n
        end

        opts.on '-D', '--rename-dirs',
        'Rename only directories instead of regular files' do |d|
          options.rename_dirs = d
        end

        opts.on '--renumber',
        'Renumber files from starting from 1 and on' do |renum|
          options.renumber = renum
        end

        opts.on '--regexp REGEXP', Regexp,
        'Use REGEXP to match filenames' do |regexp|
          options.pattern = regexp
        end

        opts.on '-v', '--[no-]verbose', 'Run verbosely' do |v|
          options.verbose = v
        end

        opts.on '-h', '--help', 'Display this message' do
          puts opts
          exit
        end

        opts.on '--version', 'Display version' do
          puts VERSION
          exit
        end
      end
    end

    def parse(args)
      # Display help if called through 'nrename' executable and without arguments:
      if args.empty? && Nrename.executable_name == 'nrename'
        args << '--help'
      end

      parser.parse! args

      if !options.execute && Nrename.executable_name == 'nrename'
        at_exit do
          warn 'No renaming is done. Run with -X option to perform actual changes.'
        end
      end

      options.dirs = extract_dirs args

      self
    end

    def extract_dirs(args)
      dirs = Set.new

      args.each do |arg|
        dir = File.expand_path arg
        if File.directory? dir
          dirs << dir
        else
          warn "#{dir} is not a valid directory."
          exit 1
        end
      end

      if options.recursive
        dirs.dup.each do |dir|
          # Workaround: every other engine except jruby does not
          # work with unescaped path:
          dir = dir.shellescape unless RUBY_ENGINE == 'jruby'

          Dir.glob(File.join dir, '**/') do |subdir|
            dirs << subdir.chomp('/')
          end
        end
      end

      dirs
    end
  end
end
