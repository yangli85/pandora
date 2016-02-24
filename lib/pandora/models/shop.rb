require 'pandora/models/base'

module Pandora
  module Models
    class Shop < Pandora::Models::Base
      scope :active, -> { where(deleted: false) }
      validates :name, :presence => true
      validates :address, :presence => true
      validates :latitude, :presence => true
      validates :longtitude, :presence => true
      has_many :designers
      has_many :promotion_logs, class_name: "Pandora::Models::ShopPromotionLog", foreign_key: :shop_id, dependent: :destroy
      has_many :shop_images, dependent: :destroy
      has_many :images, through: :shop_images, foreign_key: :image_id

      def attributes
        {
            id: id,
            name: name,
            address: address,
            latitude: latitude,
            longtitude: longtitude
        }
      end
    end
  end
end
