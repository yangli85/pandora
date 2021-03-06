require 'pandora/models/base'

module Pandora
  module Models
    class Designer < Pandora::Models::Base
      scope :vip, -> { where(is_vip: true) }
      scope :non_vip, -> { where(is_vip: false) }
      scope :non_activated, -> { where(activated: false) }
      scope :activated, -> { where(activated: true) }
      validates :user_id, :uniqueness => true, :presence => true
      has_many :twitters, -> { where(deleted: false) }, class_name: "Pandora::Models::Twitter", foreign_key: :designer_id, dependent: :destroy
      has_many :vitae, class_name: "Pandora::Models::Vita", foreign_key: :designer_id, dependent: :destroy
      has_many :favorite_designers, dependent: :destroy
      has_many :users, through: :favorite_designers

      belongs_to :user
      belongs_to :shop

      def attributes
        {
            id: id,
            user_id: user.id,
            name: user.name,
            avatar: user.avatar && user.avatar.attributes
        }
      end
    end
  end
end