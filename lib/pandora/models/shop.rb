require 'pandora/models/base'

module Pandora
  module Models
    class Shop < Pandora::Models::Base
      validates :name, :presence => true
      validates :address, :presence => true
      validates :latitude, :presence => true
      validates :longtitude, :presence => true
      has_many :designers
    end
  end
end
