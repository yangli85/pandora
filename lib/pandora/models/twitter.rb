require 'pandora/models/base'
require 'pandora/common/time_helper'

module Pandora
  module Models
    class Twitter < Pandora::Models::Base
      include Pandora::Common::TimeHelper
      default_scope -> { where(deleted: false) }
      validates :author, :presence => true
      validates :designer, :presence => true
      validates :content, :length => {:maximum => 100}
      belongs_to :author, class_name: "Pandora::Models::User", foreign_key: :author
      belongs_to :designer, class_name: "Pandora::Models::Designer", foreign_key: :designer
      has_many :twitter_images
      has_many :images, through: :twitter_images, foreign_key: :image_id
      has_many :s_images, through: :twitter_images, foreign_key: :s_image_id

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
            images: twitter_images.map(&:images),
            created_at: relative_time(created_at)
        }
      end
    end
  end
end

