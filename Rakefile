require "bundler/gem_tasks"
require "rake/testtask"

namespace :db do
  desc 'bootstrap database'
  task :setup do
    sh "createdb range_component_attributes_test || true"
    sh "psql -f test/database_structure.sql range_component_attributes_test"
  end
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :default => :test
