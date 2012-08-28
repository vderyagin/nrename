Given(/^the following empty files inside directory "([^"]*)":$/) do |directory, files|
  files.raw.each do |file,|
    write_file File.join(directory, file), ''
  end
end

Given(/^the following files with content inside directory "([^"]*)":$/) do |directory, files|
  files.raw.each do |file, content|
    write_file File.join(directory, file), content
  end
end

Given(/^the following directories inside directory "([^"]*)":$/) do |directory, dirs|
  dirs.raw.each do |dir,|
    create_dir File.join(directory, dir)
  end
end

Then(/^the following files should exist inside directory "([^"]*)":$/) do |directory, files|
  files.raw.each do |file,|
    check_file_presence Array(File.join directory, file), true
  end
end

Then(/^the following files with content should exist inside directory "([^"]*)":$/) do |directory, files|
  files.raw.each do |file, content|
    check_file_content File.join(directory, file), content, true
  end
end

Then(/^the following directories should exist inside directory "([^"]*)":$/) do |directory, dirs|
  dirs.raw.each do |dir,|
    check_directory_presence Array(File.join directory, dir), true
  end
end

Then(/^the stdout should match \/([^\/]*)\/$/) do |expected|
  assert_matching_output expected, all_stdout
end
