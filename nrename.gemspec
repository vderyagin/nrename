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

  s.files        = Dir['{bin,lib}/**/*']
  s.test_files   = Dir['{spec,features}/**/*']
  s.executables  = ['nrename']
  s.require_path = 'lib'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'aruba'
end
