require 'nrename/counter'
require 'nrename/directory'
require 'nrename/numbered_file'
require 'nrename/options'
require 'nrename/runner'
require 'nrename/utils'
require 'nrename/version'

module Nrename
  module_function

  def executable_name
    File.basename $PROGRAM_NAME
  end

  def options
    @options ||= Options.new
  end

  def parse_options(args)
    @options = Options.new
    options.parse args
  end
end
