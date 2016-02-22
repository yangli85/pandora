require 'pandora/models/base'

module Pandora
  module Models
    class Commissioner < Pandora::Models::Base
      enum statuses: [:normal, :black]
      validates :status, inclusion: {in: statuses.keys}
      validates :phone_number, :uniqueness => true, :format => {:with => /\A[\d]{11}\z/}
      validates :password, :length => {maximum: 10}
      has_many :promotion_logs, dependent: :destroy, foreign_key: :c_id
      has_many :shop_promotion_logs, foreign_key: :c_id
      belongs_to :code_image, class_name: "Pandora::Models::Image", foreign_key: :code_image_id, dependent: :destroy

      def attributes
        {
            id: id,
            name: name,
            phone_number: phone_number,
            code_image: code_image.url
        }
      end
    end
  end
end

