require 'pandora/models/ad_image'
require 'pandora/models/popup_ad'
module Pandora
  module Services
    class AdService
      def get_ad_images category
        Pandora::Models::AdImage.where(category: category)
      end

      def get_latest_popup_ad
        Pandora::Models::PopupAd.order("id desc").first
      end
    end
  end
end
