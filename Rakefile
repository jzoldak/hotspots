require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.pattern = "test/**/*_test.rb"
end

task :coverage do
  ENV["coverage"] = "true"
  Rake::Task["test"].invoke
end

task :spec    => :test
task :default => :test
