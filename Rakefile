require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['--color', '--format progress']
end

task default: :spec
