require 'aruba/cucumber'
require 'fileutils'

ENV['PATH'] = "#{File.expand_path __FILE__, '../../../bin'}#{File::PATH_SEPARATOR}#{ENV['PATH']}"

Given(/^the following empty files inside directory "([^"]*)":$/) do |directory, files|
  files.raw.each do |file_row|
    write_file "#{directory}/#{file_row[0]}", ''
  end
end

Given(/^the following directories inside directory "([^"]*)":$/) do |directory, dirs|
  dirs.raw.each do |dir_row|
    create_dir "#{directory}/#{dir_row[0]}"
  end
end

Then(/^the following files should exist inside directory "([^"]*)":$/) do |directory, files|
  files.raw.each do |file_row|
    check_file_presence ["#{directory}/#{file_row[0]}"], true
  end
end

Then(/^the following directories should exist inside directory "([^"]*)":$/) do |directory, dirs|
  dirs.raw.each do |dir_row|
    check_directory_presence ["#{directory}/#{dir_row[0]}"], true
  end
end

Then(/^the stdout should match \/([^\/]*)\/$/) do |expected|
  assert_matching_output expected, all_stdout
end

Before do
  @aruba_timeout_seconds = 10             # account for slow JVM startup
end

After do
  FileUtils.rm_rf File.expand_path('../../../tmp', __FILE__)
end
