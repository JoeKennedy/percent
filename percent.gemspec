Gem::Specification.new do |s|
  s.name     = 'percent'
  s.version  = '0.0.0'
  s.platform = Gem::Platform::RUBY
  s.license  = 'MIT'
  s.authors  = ['Joe Kennedy']
  s.summary  = 'Percent objects and integration with Rails'

  s.files = Dir.glob('{lib,spec}/**/*') + %w(percent.gemspec)
  s.files.delete = ('spec/percent.sqlite3')

  s.test_files   = s.files.grep(%r{^spec/})

  s.require_path = 'lib'

  s.add_dependency 'activesupport'

  s.add_development_dependency 'activerecord'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '>= 3.0'
  s.add_development_dependency 'sqlite3'
end
