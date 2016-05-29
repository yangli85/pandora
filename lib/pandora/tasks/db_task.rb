require 'rake'
require 'active_support'
require 'active_support/core_ext'
require 'active_record'
require 'pandora/models/designer'
require 'pandora/models/favorite_image'
require 'pandora/models/twitter_image'
require 'pandora/models/image'
require 'pandora/models/vita'
require 'pandora/models/vita_image'
require 'pandora/models/favorite_designer'
require 'pandora/models/twitter'
require 'pandora/models/promotion_log'
require 'yaml'

module Pandora
  module Tasks
    class DBTask
      include Rake::DSL if defined? Rake::DSL

      def install_tasks
        path = File.expand_path('../', File.dirname(__FILE__))

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

          desc "check change designer vip expired time every day"
          task :check_vip_expired => :environment do
            ENV['RAILS_ENV'] = ENV["RACK_ENV"] || "development"
            Pandora::Models::Designer.lock.where("expired_at < ? ", Date.today).update_all("is_vip = false")
            phone_numbers = Pandora::Models::Designer.non_vip.select(:phone_number)
            Pandora::Models::PromotionLog.where(:phone_number => phone_numbers).destroy_all
          end

          desc "update designer weekly stars every week"
          task :update_weekly_stars => :environment do
            ENV['RAILS_ENV'] = ENV["RACK_ENV"] || "development"
            Pandora::Models::Designer.lock.update_all("weekly_stars = 0")
          end

          desc "update designer monthly stars every month"
          task :update_monthly_stars => :environment do
            ENV['RAILS_ENV'] = ENV["RACK_ENV"] || "development"
            Pandora::Models::Designer.lock.update_all("monthly_stars = 0")
          end

          desc "delete inactivated designers every day"
          task :delete_non_activated_designers => :environment do
            ENV['RAILS_ENV'] = ENV["RACK_ENV"] || "development"
            Pandora::Models::Designer.non_activated.lock.destroy_all
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