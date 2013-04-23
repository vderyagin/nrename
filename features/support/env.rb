require 'aruba/cucumber'
require 'fileutils'

ENV['PATH'] = "#{File.expand_path('../../../bin', __FILE__)}#{File::PATH_SEPARATOR}#{ENV['PATH']}"

application_root = File.expand_path('../../..', __FILE__)

# Account for slow JVM startup.
Before do
  @aruba_timeout_seconds = 10
end

# Remove aruba's temporary directory after each scenario.
After do
  FileUtils.rm_rf File.expand_path 'tmp', application_root
end
