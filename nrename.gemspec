require File.expand_path '../lib/nrename', __FILE__

Gem::Specification.new do |s|
  s.name        = 'nrename'
  s.version     = Nrename::VERSION
  s.authors     = ['Victor Deryagin']
  s.email       = ['vderyagin@gmail.com']
  s.homepage    = ''
  s.summary     = ''
  s.description = ''

  s.rubyforge_project = 'nrename'

  s.files = [
    'bin/nrename',
    'lib/nrename.rb',
    'lib/nrename/directory.rb',
    'lib/nrename/options.rb',
    'lib/nrename/version.rb'
  ]

  s.test_files = [
    'features/options_processing.feature',
    'features/renaming_files.feature',
    'features/support/env.rb',
    'spec/nrename/directory_spec.rb',
    'spec/nrename/options_spec.rb',
    'spec/spec_helper.rb'
  ]

  s.executables  = ['nrename']
  s.require_path = 'lib'

  s.add_development_dependency 'rspec', '~> 2.8.0'
  s.add_development_dependency 'aruba', '~> 0.4.11'
end
