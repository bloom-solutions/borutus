require 'bundler/setup'

APP_RAKEFILE = File.expand_path('./fixture_rails_root/Rakefile')
load 'rails/tasks/engine.rake'
load 'rails/tasks/statistics.rake'

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

desc 'run specs'

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ['-c', '-f d', '-r ./spec/spec_helper.rb']
  t.pattern = 'spec/**/*_spec.rb'
end

task default: :spec
