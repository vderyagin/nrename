require 'pathname'
require 'fileutils'

module Nrename
  class Directory
    def initialize(dir)
      @dir = Pathname.new dir

      unless @dir.absolute?
        fail ArgumentError, 'directory path should be absolute.'
      end

      opts = Nrename.options

      @verbose = opts.verbose
      @execute = opts.execute
      @pattern = opts.pattern
    end

    def numbered_files
      @numbered_files ||= @dir.children
        .reject(&:directory?)
        .select { |file| file.basename.to_s =~ @pattern }
    end

    def num_field_length
      @num_field_length ||= max_number.to_s.size
    end

    def max_number
      numbered_files.map(&method(:number_for)).max
    end

    def normalize
      numbered_files.each do |old|
        new = normalized_name_for(old)
        next if old == new
        FileUtils.mv old, new, {
          :noop    => !@execute,
          :verbose => @verbose
        }
      end
    end

    def normalized_name_for(path)
      dirname, filename = path.split
      new_filename = filename.to_s
      new_filename[@pattern, 1] = adjusted_number_string_for(path)
      dirname + new_filename
    end

    def number_for(path)
      path.basename.to_s[@pattern, 1].to_i
    end

    def adjusted_number_string_for(path)
      number_for(path).to_s.rjust num_field_length, '0'
    end
  end
end
