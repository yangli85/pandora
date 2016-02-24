require 'pandora/models/base'

module Pandora
  module Models
    class ShopImage < Pandora::Models::Base
      validates :image_id, :uniqueness => true, :presence => true
      validates :shop_id, :presence => true
      belongs_to :shop
      belongs_to :image, dependent: :destroy
    end
  end
end

