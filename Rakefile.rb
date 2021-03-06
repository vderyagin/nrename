require 'rake/clean'
require "bundler/gem_tasks"

CLOBBER.include 'pkg'

desc 'Run all Rspec specs.'
task :spec do
  sh 'rspec'
end

desc 'Run all Cucumber features.'
task :cucumber do
  sh 'cucumber', '--format', 'progress'
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
