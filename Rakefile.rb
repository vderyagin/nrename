require 'rake/clean'
require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

CLOBBER.include 'pkg'

Cucumber::Rake::Task.new
RSpec::Core::RakeTask.new do |task|
  task.verbose = false
end

task :default => [:spec, :cucumber]

desc 'Generate README.md'
file 'README.md' => ['README.md.erb', 'lib/nrename/options.rb'] do
  require 'erb'

  result = ERB.new(File.read './README.md.erb').result

  File.open './README.md', 'w' do |file|
    file.puts result
  end
end
