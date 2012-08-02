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

  def self.set_options_from(args)
    @options = Options.parse args
  end

  # Return options if set by .set_options_from(args), otherwise return default ones
  def self.options
    @options ||= Options.parse []
  end
end
