require 'pandora/models/base'
require 'pandora/models/twitter_image'

module Pandora
  module Models
    class FavoriteImage < Pandora::Models::Base
      validates :user_id, :presence => true
      validates :image_id, :presence => true
      validates_uniqueness_of :image_id, :scope => :user_id
      belongs_to :user
      belongs_to :favorited_image, class_name: "Pandora::Models::Image", foreign_key: :image_id
      belongs_to :twitter, class_name: "Pandora::Models::Twitter", foreign_key: :twitter_id
      after_create :add_image_likes
      after_destroy :minus_image_likes

      def add_image_likes
        twitter_image = twitter.twitter_images.where(image_id: image_id).first
        twitter_image.update(likes: twitter_image.likes+1)
      end

      def minus_image_likes
        twitter_image = twitter.twitter_images.where(image_id: image_id).first
        twitter_image.update(likes: twitter_image.likes-1)
      end
    end
  end
end

