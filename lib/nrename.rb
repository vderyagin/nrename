libdir = File.expand_path(File.dirname __FILE__)
$:.push libdir unless $:.include? libdir

require 'nrename/counter'
require 'nrename/directory'
require 'nrename/numbered_file'
require 'nrename/options'
require 'nrename/runner'
require 'nrename/utils'
require 'nrename/version'

module Nrename
  def self.executable_name
    File.basename $PROGRAM_NAME
  end

  def self.options
    @options ||= Options.new
  end

  def self.parse_options(args)
    @options = Options.new
    options.parse args
  end
end
