require 'pandora/models/base'

module Pandora
  module Models
    class User < Pandora::Models::Base
      enum genders: [:male, :female, :unknow]
      enum statuses: [:nomal, :black]
      validates :gender, inclusion: {in: genders.keys}
      validates :status, inclusion: {in: statuses.keys}
      validates :phone_number, :uniqueness => true, :format => {:with => /\A[\d]{11}\z/}
      has_one :account, class_name: "Pandora::Models::Account"
      has_many :twitters, class_name: "Pandora::Models::Twitter", foreign_key: :author
      has_many :messages
      has_many :favorite_images
      has_many :favorite_designers
      has_many :favorited_images, through: :favorite_images
      has_many :favorited_designers, through: :favorite_designers
      has_one :designer
      belongs_to :avatar, class_name: "Pandora::Models::Image", foreign_key: :image_id

      def attributes
        {
            id: id,
            name: name,
            avatar: avatar.url
        }
      end
    end
  end
end

