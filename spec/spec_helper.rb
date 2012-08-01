require 'rspec'
require 'fileutils'

require File.expand_path '../../lib/nrename', __FILE__

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
