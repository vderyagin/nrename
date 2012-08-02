require 'rake/clean'
require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

CLOBBER.include 'pkg'

RSpec::Core::RakeTask.new
Cucumber::Rake::Task.new

task :default => [:spec, :cucumber]

desc 'Generate README.md'
file 'README.md' => 'README.md.erb' do
  require 'erb'

  result = ERB.new(File.read './README.md.erb').result

  File.open './README.md', 'w' do |file|
    file.puts result
  end
end
