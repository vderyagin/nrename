libdir = File.expand_path(File.dirname __FILE__)
$:.push libdir unless $:.include? libdir

require 'nrename/directory'
require 'nrename/options'
require 'nrename/runner'
require 'nrename/version'

module Nrename
  def self.executable_name
    File.basename $PROGRAM_NAME
  end

  def self.options
    Options.instance
  end

  def self.parse_options(args)
    options.parse args
  end
end
