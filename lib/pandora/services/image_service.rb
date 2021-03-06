require 'pandora/models/image'

module Pandora
  module Services
    class ImageService
      def get_image id
        Pandora::Models::Image.find(id)
      end
    end
  end
end
