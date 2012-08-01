libdir = File.expand_path(File.dirname __FILE__)
$:.push libdir unless $:.include? libdir

require 'nrename/version'
require 'nrename/directory'
require 'nrename/options'

module Nrename
  def self.executable_name
    File.basename $PROGRAM_NAME
  end

  def self.options
    # return default options if not alredy set by .run():
    @options ||= Options.parse []
  end

  def self.run(args)
    @options = Options.parse args

    dirs = options.dirs.map { |dir| Directory.new dir }
    if dirs.all? &:empty?
      warn 'No matched files to rename.'
    else
      dirs.each &:normalize
    end
  end
end
