require "bundler/gem_tasks"
require "bundler/setup"

desc "Run the tests."
task :test do
  $: << "lib" << "test"
  Dir["test/*_test.rb"].each { |f| require f[5..-4] }
end

task :default => :test
