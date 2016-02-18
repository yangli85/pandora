require 'pandora/models/base'

module Pandora
  module Models
    class TwitterImage < Pandora::Models::Base
      validates :image_id, :uniqueness => true, :presence => true
      validates :twitter_id, :presence => true
      validates :rank, :presence => true
      belongs_to :twitter
      belongs_to :s_image, class_name: "Pandora::Models::Image"
      belongs_to :image, class_name: "Pandora::Models::Image"

      def images
        {
            s_image: s_image && s_image.url,
            image: image && image.url,
            likes: likes,
            rank: rank
        }
      end

      def attributes
        {
            s_image: s_image && s_image.url,
            image: image && image.url,
            likes: likes,
            designer: designer.atrributes,
            twitter_id: twitter_id,
            rank: rank
        }
      end
    end
  end
end

