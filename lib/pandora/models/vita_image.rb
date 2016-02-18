require 'pandora/models/base'

module Pandora
  module Models
    class VitaImage < Pandora::Models::Base
      validates :image_id, :uniqueness => true, :presence => true
      belongs_to :vita
      belongs_to :s_image, class_name: "Pandora::Models::Image", dependent: :destroy
      belongs_to :image, class_name: "Pandora::Models::Image", dependent: :destroy
      validates :vita_id, :presence => true

      def images
        {
            s_image: s_image && s_image.url,
            image: image && image.url
        }
      end
    end
  end
end

