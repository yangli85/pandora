require 'pandora/models/twitter_image'

module Pandora
  module Services
    class TwitterService
      def get_ordered_twitter_images page_size, current_page, order_by
        Pandora::Models::TwitterImage.order("#{order_by} desc").limit(page_size).offset((current_page-1)*page_size)
      end
    end
  end
end