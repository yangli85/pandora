require 'pandora/models/base'

module Pandora
  module Models
    class User < Pandora::Models::Base
      enum genders: [:male, :female, :unknow]
      enum statuses: [:normal, :black]
      validates :gender, inclusion: {in: genders.keys}
      validates :status, inclusion: {in: statuses.keys}
      validates :phone_number, :uniqueness => true, :format => {:with => /\A[\d]{11}\z/}
      has_many :twitters, class_name: "Pandora::Models::Twitter", foreign_key: :author_id, dependent: :destroy
      has_many :messages, dependent: :destroy
      has_many :favorite_images, dependent: :destroy
      has_many :favorite_designers, dependent: :destroy
      has_many :favorited_images, through: :favorite_images, dependent: :destroy
      has_many :favorited_designers, through: :favorite_designers, dependent: :destroy
      has_one :designer, dependent: :destroy
      has_one :account, dependent: :destroy
      has_one :login_user, dependent: :destroy
      belongs_to :avatar, class_name: "Pandora::Models::Image", foreign_key: :image_id, dependent: :destroy

      def attributes
        {
            id: id,
            name: name,
            avatar: avatar && avatar.attributes
        }
      end
    end
  end
end

