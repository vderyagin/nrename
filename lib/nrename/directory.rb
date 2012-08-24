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

    def files
      @dir.children.reject &:directory?
    end

    def numbered_files
      @numbered_files ||= files.
        select { |file| file.basename.to_s =~ options.pattern }.
        map &(NumberedFile.method :new)
    end

    def num_field_length
      @num_field_length ||= max_number.to_s.size
    end

    def max_number
      numbered_files.map(&:number).max
    end

    def normalize
      numbered_files.each do |file|
        file.normalize num_field_length
      end
    end
  end
end
