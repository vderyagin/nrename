require 'pathname'
require 'fileutils'
require 'forwardable'

module Nrename
  class NumberedFile
    attr_reader :path, :number_length

    extend Forwardable

    def_delegator :Nrename, :options

    def initialize(path)
      @path = path
    end

    def number
      path.basename.to_s[options.pattern, 1].to_i
    end

    def normalize(length)
      @number_length = length
      new_name = normalized_path
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
      number.to_s.rjust number_length, '0'
    end
  end
end
