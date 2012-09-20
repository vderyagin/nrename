require 'pathname'

module Nrename
  module Utils
    def all_subdirs_of(dir)
      each_subdir(dir).with_object([]) do |subdir, children|
        children << subdir
        children.concat all_subdirs_of subdir
      end
    end
    module_function :all_subdirs_of

    def each_subdir(dir, &block)
      dir = Pathname.new dir
      dir.children.select(&:directory?).map(&:to_s).each &block
    end
    module_function :each_subdir
  end
end
