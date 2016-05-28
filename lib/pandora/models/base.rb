require 'active_record'

module Pandora
  module Models
    class Base < ::ActiveRecord::Base
      self.abstract_class = true
      dbconfig = YAML::load(ERB.new(File.read(File.expand_path('../db/database.yml', File.dirname(__FILE__)))).result)
      env = ENV["RACK_ENV"] || "development"
      establish_connection dbconfig[env]

    end
  end
end