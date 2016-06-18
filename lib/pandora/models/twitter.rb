require 'pandora/models/base'
require 'pandora/common/time_helper'

module Pandora
  module Models
    class Twitter < Pandora::Models::Base
      include Pandora::Common::TimeHelper
      scope :active, -> { where(deleted: false) }
      validates :author, :presence => true
      validates :designer, :presence => true
      validates :content, :length => {:maximum => 100}
      belongs_to :author, class_name: "Pandora::Models::User", foreign_key: :author_id
      belongs_to :designer, class_name: "Pandora::Models::Designer", foreign_key: :designer_id
      has_many :twitter_images
      has_many :images, through: :twitter_images, foreign_key: :image_id
      has_many :favorite_images, foreign_key: :twitter_id
      before_destroy :delete_favorite_images

      def delete_favorite_images
        favorite_images.destroy_all
        twitter_images.destroy_all
      end

      def likes
        twitter_images.map(&:likes).inject(0, :+)
      end

      def attributes
        {
            id: id,
            author: author.attributes,
            content: content,
            likes: likes,
            designer: designer.attributes,
            image_count: image_count,
            images: twitter_images.order("rank asc").map(&:images),
            created_at: relative_time(created_at)
        }
      end
    end
  end
end

