require 'pandora/models/base'

module Pandora
  module Models
    class Image < Pandora::Models::Base
      enum categories: [:avatar, :twitter, :vita, :ad, :QR_code, :unknow]
      validates :category, inclusion: {in: categories.keys}
      validates :url, :presence => true
      has_many :s_images, class_name: "Pandora::Models::Image", foreign_key: :original_image_id, dependent: :destroy
      belongs_to :original_image, class_name: "Pandora::Models::Image", foreign_key: :original_image_id

      def attributes
        {
            id: id,
            url: url,
            s_url: s_url
        }
      end

      def s_url
        s_images.first.url unless s_images.empty?
      end
    end
  end
end

