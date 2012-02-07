libdir = File.expand_path(File.dirname __FILE__)
$:.push libdir unless $:.include? libdir

require 'nrename/version'
require 'nrename/directory'
require 'nrename/options'

module Nrename
  def self.options
    # return default options if not alredy set by .run():
    @options ||= Options.parse []
  end

  def self.run(args=[])
    @options = Options.parse args

    options.dirs
      .map { |dir| Directory.new dir }
      .each &:normalize
  end
end
