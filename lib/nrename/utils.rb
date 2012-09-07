require 'pathname'
require 'set'

module Nrename
  module Utils
    def all_subdirs_of(dir)
      dir = Pathname.new dir

      children = Set.new

      dir.children.select(&:directory?).map(&:to_s).each do |child|
        children.add child
        children.merge all_subdirs_of child
      end

      Array children
    end
    module_function :all_subdirs_of
  end
end
