require 'optparse'
require 'ostruct'
require 'singleton'
require 'forwardable'

module Nrename
  class Options
    include Singleton

    class << self
      extend Forwardable
      def_delegator :instance, :parse
    end

    def reset
      @options = nil
    end

    def default_options
      {
        :numbers_only => false,
        :dirs         => [],
        :execute      => false,
        :pattern      => /(\d+)/,
        :recursive    => false,
        :verbose      => true
      }
    end

    def options
      @options ||= OpenStruct.new default_options
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
      reset

      # display help if called through 'nrename' executable
      # and without arguments

      if args.empty? && Nrename.executable_name == 'nrename'
        args << '--help'
      end


      parser.parse! args

      if !options.execute && Nrename.executable_name == 'nrename'
        at_exit do
          warn 'No renaming is done. Run with -X option to perform actual changes.'
        end
      end


      args.each do |arg|
        dir = File.expand_path arg
        if File.directory? dir
          options.dirs << dir
        else
          warn "#{dir} is not a valid directory."
          exit 1
        end
      end

      if options.recursive
        options.dirs.dup.each do |dir|
          Dir.glob(File.join dir, '**/') do |subdir|
            options.dirs << subdir.chomp('/')
          end
        end
      end

      options.dirs.uniq!

      options
    end
  end
end
