require 'pandora/models/base'

module Pandora
  module Models
    class PopupAd < Pandora::Models::Base
      enum categories: [:INTERNAL_LINK, :EXTERNAL_LINK]
      validates :category, inclusion: {in: categories.keys}
      validates :link, :presence => true
      validates :image_url, :presence => true

      def attributes
        {
            category: category,
            link: link,
            image_url: image_url
        }
      end
    end
  end
end

