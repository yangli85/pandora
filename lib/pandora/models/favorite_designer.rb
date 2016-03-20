require 'pandora/models/base'

module Pandora
  module Models
    class FavoriteDesigner < Pandora::Models::Base
      validates :user_id, :presence => true
      validates :designer_id, :presence => true
      validates_uniqueness_of :designer_id, :scope => :user_id
      belongs_to :favorited_designer, class_name: "Pandora::Models::Designer", foreign_key: :designer_id
      belongs_to :user, class_name: "Pandora::Models::User"
      after_create :add_designer_likes
      after_destroy :minus_designer_likes

      def add_designer_likes
        favorited_designer.update(likes: favorited_designer.likes+1)
      end

      def minus_designer_likes
        favorited_designer.update(likes: favorited_designer.likes-1)
      end
    end
  end
end

