require 'pandora/models/twitter_image'
require 'pandora/models/twitter'
require 'pandora/models/user'
require 'pandora/models/designer'
require 'pandora/models/image'
require 'pandora/common/service_helper'

module Pandora
  module Services
    class TwitterService
      include Pandora::Common::ServiceHelper

      def get_ordered_twitter_images page_size, current_page, order_by
        Pandora::Models::TwitterImage.order("#{order_by} desc").limit(page_size).offset((current_page-1)*page_size)
      end

      def get_twitter_images id
        Pandora::Models::TwitterImage.where(twitter_id: id).order('rank asc')
      end

      def get_ordered_twitters page_size, current_page, order_by
        Pandora::Models::Twitter.order("#{order_by} desc").limit(page_size).offset((current_page-1)*page_size)
      end

      def search_twitter_by_id id
        begin
          Pandora::Models::Twitter.where(id: id).first
        rescue => e
        end
      end

      def create_twitter author_id, designer_id, content, image_paths, stars, latitude, longtitude, twitter_images_folder
        author = Pandora::Models::User.find_by_id(author_id)
        designer = Pandora::Models::Designer.find_by_id(designer_id)
        twitter = Pandora::Models::Twitter.create!(author: author, designer: designer, content: content, latitude: latitude, longtitude: longtitude, stars: stars, image_count: image_paths.length)

        image_paths.each_with_index do |path, index|
          s_image_path = move_image_to path[:s_image_path], twitter_images_folder
          s_image = Pandora::Models::Image.create!(category: 'twitter', url: s_image_path)
          image_path = move_image_to path[:image_path], twitter_images_folder
          image = Pandora::Models::Image.create!(category: 'twitter', url: image_path, s_image: s_image)
          Pandora::Models::TwitterImage.create!(twitter_id: twitter.id, image: image, rank: index+1)
        end
      end
    end
  end
end