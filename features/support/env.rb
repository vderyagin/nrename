require 'aruba/cucumber'

ENV['PATH'] = "#{File.expand_path __FILE__, '../../../bin'}#{File::PATH_SEPARATOR}#{ENV['PATH']}"

Given(/^the following empty files inside directory "([^"]*)":$/) do |directory, files|
  files.raw.each do |file_row|
    write_file "#{directory}/#{file_row[0]}", ''
  end
end

Then(/^the stdout should match \/([^\/]*)\/$/) do |expected|
  assert_matching_output expected, all_stdout
end

Then(/^the following files should exist inside directory "([^"]*)":$/) do |directory, files|
  files.raw.each do |file_row|
    check_file_presence ["#{directory}/#{file_row[0]}"], true
  end
end
