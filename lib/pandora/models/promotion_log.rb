require 'pandora/models/base'

module Pandora
  module Models
    class PromotionLog < Pandora::Models::Base
      validates :phone_number, :format => {:with => /\A[\d]{11}\z/} , unless: 'phone_number.nil?'
      belongs_to :commissioner, foreign_key: :c_id
      validates :commissioner, :presence => true

      def attributes
        {
            id: id,
            phone_number: phone_number,
            mobile_type: mobile_type,
            commissioner: commissioner.attributes
        }
      end
    end
  end
end

