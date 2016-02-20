require 'pandora/models/base'

module Pandora
  module Models
    class Image < Pandora::Models::Base
      enum categories: [:avatar, :twitter, :vita, :ad, :unknow]
      validates :category, inclusion: {in: categories.keys}
      validates :url, :presence => true
      has_one :s_image, class_name: "Pandora::Models::Image", foreign_key: :s_image_id, dependent: :destroy

      def attributes
        {
            id: id,
            url: url,
            s_url: s_image && s_image.url
        }
      end
    end
  end
end

