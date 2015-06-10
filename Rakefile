require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "execute benchmark script"
task :bm do
  load 'spec/csvbm.rb'
end

