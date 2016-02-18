require 'pandora/models/twitter_image'
require 'pandora/models/twitter'
require 'pandora/models/user'
require 'pandora/models/designer'
require 'pandora/models/image'

module Pandora
  module Services
    class TwitterService
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
        Pandora::Models::Twitter.find(id)
      end

      def create_twitter author_id, designer_id, content, image_paths, stars, latitude, longtitude
        author = Pandora::Models::User.find_by_id(author_id)
        designer = Pandora::Models::Designer.find_by_id(designer_id)
        twitter = Pandora::Models::Twitter.create!(author: author, designer: designer, content: content, latitude: latitude, longtitude: longtitude, stars: stars, image_count: image_paths.length)
        image_paths.each_with_index do |image_path, index|
          image = Pandora::Models::Image.create!(category: 'twitter', url: image_path[:image_path])
          s_image = Pandora::Models::Image.create!(category: 'twitter', url: image_path[:s_image_path])
          Pandora::Models::TwitterImage.create!(twitter_id: twitter.id, s_image: s_image, image: image, rank: index+1)
        end
      end
    end
  end
end