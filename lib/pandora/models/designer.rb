require 'pandora/models/base'

module Pandora
  module Models
    class Designer < Pandora::Models::Base
      scope :vip, -> { where(is_vip: true) }
      validates :user_id, :uniqueness => true, :presence => true
      has_many :twitters, class_name: "Pandora::Models::Twitter", foreign_key: :designer
      has_many :vitae, class_name: "Pandora::Models::Vita", foreign_key: :designer_id
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