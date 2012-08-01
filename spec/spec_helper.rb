require 'rspec'
require 'fileutils'

require File.expand_path '../../lib/nrename', __FILE__

# Monkey-patch to all few aliases for more human-readable specs.
# For instance:
#
# expect(something.verbose).to be_true
# vs.
# expect(something).to be_verbose
class Nrename::Options
  alias_method :recursive?, :recursive
  alias_method :verbose?, :verbose
end

module Support
  def inside(dir, &block)
    mkdir dir unless File.exists? dir
    cd dir, &block
  end
end

RSpec.configure do |config|
  config.include FileUtils
  config.include Support

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
