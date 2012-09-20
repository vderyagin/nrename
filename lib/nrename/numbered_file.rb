require 'pathname'
require 'fileutils'
require 'forwardable'

module Nrename
  class NumberedFile
    attr_reader :path, :dir

    extend Forwardable

    def_delegator Nrename, :options
    def_delegators :dir, :counter, :num_field_length

    def initialize(path, dir)
      @path = path
      @dir = dir
    end

    def number
      @number ||= options.renumber ? counter.next : number_from_path
    end

    def number_from_path
      path.basename.to_s[options.pattern, 1].to_i
    end

    def normalize
      rename_to normalized_path
    end

    def rename_to(new_name)
      return if path == new_name

      FileUtils.mv path, new_name, {
        :noop    => !options.execute,
        :verbose => options.verbose
      }
    end

    def normalized_path
      dirname, filename = path.split
      new_filename = filename.to_s

      if options.numbers_only
        name = adjusted_number
        extname = filename.extname
        new_filename = "#{name}#{extname}"
      else
        new_filename[options.pattern, 1] = adjusted_number
      end

      dirname + new_filename
    end

    def adjusted_number
      number.to_s.rjust num_field_length, '0'
    end
  end
end
