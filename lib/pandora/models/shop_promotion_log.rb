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
            content: content,
            commissioner: commissioner && commissioner.attributes,
            created_at: created_at
        }
      end
    end
  end
end

