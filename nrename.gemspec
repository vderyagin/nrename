require File.expand_path('../lib/nrename/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'nrename'
  s.version     = Nrename::VERSION
  s.authors     = ['Victor Deryagin']
  s.email       = ['vderyagin@gmail.com']
  s.homepage    = ''
  s.summary     = ''
  s.description = ''

  s.rubyforge_project = 'nrename'

  s.license = 'MIT'
  s.required_rubygems_version = ">= 1.3.6"

  s.files = [
    'MIT-LICENSE',
    'README.md',
    'bin/nrename',
    'features/options_processing.feature',
    'features/renaming_files.feature',
    'features/support/env.rb',
    'lib/nrename.rb',
    'lib/nrename/directory.rb',
    'lib/nrename/options.rb',
    'lib/nrename/version.rb',
    'spec/nrename/directory_spec.rb',
    'spec/nrename/options_spec.rb',
    'spec/spec_helper.rb'
  ]

  s.executables  = ['nrename']
  s.require_path = 'lib'

  s.add_development_dependency 'rake',  '~> 0.9.2'
  s.add_development_dependency 'rspec', '~> 2.8.0'
  s.add_development_dependency 'aruba', '~> 0.4.11'
end
