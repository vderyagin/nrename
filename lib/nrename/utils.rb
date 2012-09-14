require 'pathname'

module Nrename
  module Utils
    def all_subdirs_of(dir)
      dir = Pathname.new dir

      children = []

      dir.children.select(&:directory?).map(&:to_s).each do |child|
        children << child
        children.concat all_subdirs_of child
      end

      children
    end
    module_function :all_subdirs_of
  end
end
