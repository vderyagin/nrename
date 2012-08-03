require 'pathname'
require 'fileutils'
require 'forwardable'

module Nrename
  class Directory

    extend Forwardable

    def_delegator :numbered_files, :empty?

    def_delegator :Nrename, :options

    def_delegator :options, :execute, :execute?
    def_delegator :options, :numbers_only, :numbers_only?
    def_delegator :options, :pattern
    def_delegator :options, :verbose, :verbose?

    def initialize(dir)
      @dir = Pathname.new dir
    end

    def numbered_files
      @numbered_files ||= @dir.children.select { |file|
        !file.directory? && file.basename.to_s =~ pattern
      }
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
          :noop    => !execute?,
          :verbose => verbose?
        }
      end
    end

    def normalized_name_for(path)
      dirname, filename = path.split
      new_filename = filename.to_s
      if numbers_only?
        name = adjusted_number_string_for path
        extname = filename.extname
        new_filename = "#{name}#{extname}"
      else
        new_filename[pattern, 1] = adjusted_number_string_for(path)
      end
      dirname + new_filename
    end

    def number_for(path)
      path.basename.to_s[pattern, 1].to_i
    end

    def adjusted_number_string_for(path)
      number_for(path).to_s.rjust num_field_length, '0'
    end
  end
end
