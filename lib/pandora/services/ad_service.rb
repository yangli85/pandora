require 'pandora/models/ad_image'
module Pandora
  module Services
    class AdService
      def get_ad_images category
        Pandora::Models::AdImage.where(category: category)
      end
    end
  end
end
