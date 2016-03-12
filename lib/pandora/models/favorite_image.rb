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
    end
  end
end

