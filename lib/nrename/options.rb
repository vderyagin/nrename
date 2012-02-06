require 'optparse'
require 'ostruct'

module Nrename
  module Options
    def self.parse(args)
      default_options = {
        :numbers_only => false,
        :dirs         => [],
        :execute      => false,
        :pattern      => /(\d+)/,
        :recursive    => false,
        :verbose      => true
      }

      options = OpenStruct.new default_options

      executable_name = File.basename $PROGRAM_NAME

      # display help if called through 'nrename' executable
      # and without arguments
      if args.empty? && executable_name == 'nrename'
        args << '--help'
      end

      OptionParser.new do |opts|
        opts.banner = "Usage: #{executable_name} [OPTINS] [DIR]..."

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
      end.parse!(args)

      args.each do |arg|
        dir = File.expand_path arg
        if File.directory? dir
          options.dirs << dir
        else
          warn "#{dir} is not a valid directory."
          exit 1
        end
      end

      if options.dirs.empty?
        options.dirs << File.expand_path('.')
      end

      if options.recursive
        options.dirs.dup.each do |dir|
          Dir.glob "#{dir}/**/" do |subdir|
            options.dirs << subdir.chomp('/')
          end
        end
      end

      options.dirs.uniq!

      options
    end
  end
end
