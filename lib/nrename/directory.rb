require 'pathname'
require 'fileutils'
require 'forwardable'

module Nrename
  class Directory
    extend Forwardable

    def_delegator :numbered_files, :empty?
    def_delegator Nrename, :options

    attr_reader :counter

    def initialize(dir)
      @dir = Pathname.new dir
      @counter = Counter.new
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
        map { |file| NumberedFile.new file, self }.
        sort_by(&:number_from_path)
    end

    def num_field_length
      @num_field_length ||= max_number.to_s.size
    end

    def max_number
      if options.renumber
        numbered_files.size
      else
        numbered_files.map(&:number_from_path).max
      end
    end

    def normalize
      numbered_files.each do |file|
        file.normalize
      end
    end
  end
end
