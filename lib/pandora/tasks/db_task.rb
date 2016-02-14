require 'rake'
require 'active_support'
require 'active_support/core_ext'
require 'active_record'
require 'yaml'

module Pandora
  module Tasks
    class DBTask
      include Rake::DSL if defined? Rake::DSL

      def install_tasks
        path = File.expand_path('../',File.dirname(__FILE__))

        namespace :pandora_db do
          desc 'Creates the database from config/database.yml for the current RAILS_ENV. Without RAILS_ENV it defaults to creating the development database'
          task :create => :environment do
            ENV['RAILS_ENV'] = ENV["RACK_ENV"] || "development"
            ActiveRecord::Base.configurations = YAML.load(ERB.new(File.read("#{path}/db/database.yml")).result)
            ActiveRecord::Tasks::DatabaseTasks.create_current(ENV['RAILS_ENV'])
          end

          desc 'Drops the database from config/database.yml for the current RAILS_ENV. Without RAILS_ENV it defaults to dropping the development database'
          task :drop => :environment do
            ENV['RAILS_ENV'] = ENV["RACK_ENV"] || "development"
            ActiveRecord::Base.configurations = YAML.load(ERB.new(File.read("#{path}/db/database.yml")).result)
            ActiveRecord::Tasks::DatabaseTasks.drop_current(ENV['RAILS_ENV'])
          end

          desc 'Migrate the leads database through scripts in db/migrate/.'
          task :migrate => :environment do
            ActiveRecord::Migrator.migrate("#{path}/db/migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
            ActiveRecord::SchemaDumper.dump ActiveRecord::Base.connection, File.open("#{path}/db/schema.rb", 'w')
          end

          desc 'Migrate the leads database through scripts in db/migrate/.,e.g., rake leads_db:rollback STEP=2'
          task :rollback => :environment do
            ActiveRecord::Migrator.rollback("#{path}/db/", ENV["STEP"] ? ENV["STEP"].to_i : 1)
          end

          desc "Insert default data into database"
          task :seed, [:seeds_file_path] => :environment do |t, args|
            args.with_defaults(seeds_file_path: "#{path}/db/seeds.rb")
            load args[:seeds_file_path]
          end

          task :environment do
            dbconfig = YAML.load(ERB.new(File.read("#{path}/db/database.yml")).result)
            env = ENV["RACK_ENV"] || "development"
            ActiveRecord::Base.establish_connection(dbconfig[env])
          end
        end
      end
    end
  end
end