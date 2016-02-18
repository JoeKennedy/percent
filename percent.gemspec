Gem::Specification.new do |s|
  s.name     = 'percent'
  s.version  = '0.0.1'
  s.platform = Gem::Platform::RUBY
  s.license  = 'MIT'
  s.authors  = ['Joe Kennedy']
  s.email    = ['joseph.stephen.kennedy@gmail.com']
  s.summary  = 'Percent objects and integration with Rails'
  s.homepage = 'https://github.com/JoeKennedy/percent'

  s.files = Dir.glob('{lib,spec}/**/*') + %w(percent.gemspec)
  s.files.delete 'spec/percent.sqlite3'

  s.test_files   = s.files.grep(%r{^spec/})

  s.require_path = 'lib'

  s.add_dependency 'activesupport', '~> 4.2'

  s.add_development_dependency 'activerecord', '~> 4.2'
  s.add_development_dependency 'bundler',      '~> 1.11'
  s.add_development_dependency 'rake',         '~> 10'
  s.add_development_dependency 'rspec',        '~> 3.0'
  s.add_development_dependency 'sqlite3',      '~> 1.3'
end
