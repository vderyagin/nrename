require 'pathname'

module Nrename
  module Utils
    def all_subdirs_of(dir)
      children = []

      each_subdir(dir) do |subdir|
        children << subdir
        children.concat all_subdirs_of subdir
      end

      children
    end
    module_function :all_subdirs_of

    def each_subdir(dir, &block)
      dir = Pathname.new dir

      subdirs = dir.children.select &:directory?

      subdirs.each do |subdir|
        block.call subdir.to_s
      end
    end
    module_function :each_subdir
  end
end
