require 'pathname'
require 'fileutils'
require 'forwardable'

module Nrename
  class Directory
    extend Forwardable

    def_delegator :numbered_files, :empty?
    def_delegator :Nrename, :options

    def initialize(dir)
      @dir = Pathname.new dir
    end

    def directories
      @dir.children.select &:directory?
    end

    def regular_files
      @dir.children.select &:file?
    end

    def files
      options.rename_dirs ? directories : regular_files
    end

    def numbered_files
      @numbered_files ||= files.
        select { |file| file.basename.to_s =~ options.pattern }.
        map { |file| NumberedFile.new file }.
        sort_by(&:number)
    end

    def num_field_length
      @num_field_length ||= max_number.to_s.size
    end

    def max_number
      if options.renumber
        numbered_files.size
      else
        numbered_files.map(&:number).max
      end
    end

    def renumber
      numbered_files.each_with_index do |file, idx|

        # Force 1-based indexing (could use Enumerator#with_index with
        # argument, but that would be incompatible with ruby-1.8).
        idx += 1

        file.normalize num_field_length, idx
      end
    end

    def fix_numbers
      numbered_files.each do |file|
        file.normalize num_field_length
      end
    end

    def normalize
      options.renumber ? renumber : fix_numbers
    end
  end
end
