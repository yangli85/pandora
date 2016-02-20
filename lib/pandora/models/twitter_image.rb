require 'pandora/models/base'

module Pandora
  module Models
    class TwitterImage < Pandora::Models::Base
      validates :image_id, :uniqueness => true, :presence => true
      validates :twitter_id, :presence => true
      validates :rank, :presence => true
      belongs_to :twitter
      belongs_to :image, class_name: "Pandora::Models::Image"

      def images
        {
            image: image && image.attributes,
            likes: likes,
            rank: rank
        }
      end

      def attributes
        {
            image: image && image.attributes,
            likes: likes,
            designer: twitter.designer.attributes,
            twitter_id: twitter_id,
            rank: rank
        }
      end
    end
  end
end

