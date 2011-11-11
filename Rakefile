require 'rubygems'
require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

desc "Default: run unit tests"
task :default => :spec
task :test => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

