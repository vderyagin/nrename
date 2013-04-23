require File.expand_path('../lib/nrename/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'nrename'
  s.version     = Nrename::VERSION
  s.authors     = ['Victor Deryagin']
  s.email       = ['vderyagin@gmail.com']
  s.homepage    = 'https://github.com/vderyagin/nrename'
  s.summary     = 'Command-line utility for renaming numbered files.'
  s.description = 'Nrename lets you rename set of numbered files so that they can be sorted correctly in any shell or file manager.'

  s.rubyforge_project = 'nrename'

  s.license = 'MIT'
  s.required_rubygems_version = '>= 1.3.6'

  s.files = [
    'MIT-LICENSE',
    'README.md',
    'bin/nrename',
    'features/options_processing.feature',
    'features/renaming_files.feature',
    'features/support/env.rb',
    'lib/nrename.rb',
    'lib/nrename/counter.rb',
    'lib/nrename/directory.rb',
    'lib/nrename/numbered_file.rb',
    'lib/nrename/options.rb',
    'lib/nrename/runner.rb',
    'lib/nrename/utils.rb',
    'lib/nrename/version.rb',
    'spec/nrename/directory_spec.rb',
    'spec/nrename/numbered_file_spec.rb',
    'spec/nrename/options_spec.rb',
    'spec/nrename/utils_spec.rb',
    'spec/spec_helper.rb'
  ]

  s.executables  = ['nrename']
  s.require_path = 'lib'

  s.add_development_dependency 'aruba',       '~> 0.5.1'
  s.add_development_dependency 'guard-rspec', '~> 2.5.4'
  s.add_development_dependency 'rake',        '~> 10.0.3'
  s.add_development_dependency 'rb-inotify',  '~> 0.9.0'
end
