require 'pandora/models/base'

module Pandora
  module Models
    class ShopPromotionLog < Pandora::Models::Base
      belongs_to :commissioner, foreign_key: :c_id
      belongs_to :shop
      validates :commissioner, :presence => true
      validates :shop, :presence => true

      def attributes
        {
            id: id,
            shop: shop.attributes,
            commissioner: commissioner.attributes,
            content: content
        }
      end
    end
  end
end

