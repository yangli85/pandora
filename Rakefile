require "bundler_geminabox/gem_tasks"

require 'rspec/core/rake_task'
require 'pandora/tasks/db_task'

Pandora::Tasks::DBTask.new.install_tasks

RSpec::Core::RakeTask.new(:spec)
task :default => :spec

namespace :test do
  task :environment do
    ENV['RACK_ENV'] = 'test'
  end

  desc "Run all tests"
  task :all do
    Rake::Task["test:environment"].invoke
    Rake::Task["pandora_db:drop"].invoke
    Rake::Task["pandora_db:create"].invoke
    Rake::Task["pandora_db:migrate"].invoke
    Rake::Task["spec"].invoke
  end
end
