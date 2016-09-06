require 'pandora/models/commissioner'
require 'pandora/models/promotion_log'
require 'pandora/models/shop_promotion_log'
require 'pandora/common/service_helper'
require 'pandora/models/image'
require 'pandora/models/user'
require 'pandora/models/designer'
require 'pandora/models/shop_image'
require 'pandora/models/shop'
require 'pandora/models/shared_twitter'

module Pandora
  module Services
    class CommissionerService
      include Pandora::Common::ServiceHelper

      def get_commissioner phone_number
        Pandora::Models::Commissioner.find_by_phone_number(phone_number)
      end

      def get_commissioner_by_id id
        Pandora::Models::Commissioner.find(id)
      end

      def update_commssioner_scanned_times c_id
        commissioner = Pandora::Models::Commissioner.find(c_id)
        commissioner.update(be_scanned_times: commissioner.be_scanned_times+1)
      end

      def register phone_number, name, password
        Pandora::Models::Commissioner.create!(phone_number: phone_number, name: name, password: password)
      end

      def add_code_image c_id, code_image_path, code_image_folder
        image_path = move_image_to code_image_path, code_image_folder
        code_image = Pandora::Models::Image.create!(category: 'QR_code', url: image_path)
        commissioner = Pandora::Models::Commissioner.find(c_id)
        commissioner.update!(code_image_id: code_image.id)
      end

      def get_promotion_logs c_id, page_size, current_page
        commissioner = Pandora::Models::Commissioner.find c_id
        commissioner.promotion_logs.order("created_at desc").limit(page_size).offset(page_size*(current_page-1))
      end

      def get_promotion_logs_count c_id
        commissioner = Pandora::Models::Commissioner.find c_id
        commissioner.promotion_logs.count
      end

      def get_promotion_log phone_number
        Pandora::Models::PromotionLog.find_by_phone_number(phone_number)
      end

      def delete_promotion_log log_id
        Pandora::Models::PromotionLog.find(log_id).destroy
      end

      def add_promotion_log c_id, user_phone_number, mobile_type
        Pandora::Models::PromotionLog.create!(c_id: c_id, phone_number: user_phone_number, mobile_type: mobile_type)
      end

      def get_promotion_users c_id, page_size, current_page
        phone_numbers = Pandora::Models::PromotionLog.select(:phone_number).order("created_at desc").where(c_id: c_id).uniq
        Pandora::Models::User.where(phone_number: phone_numbers).order("created_at desc").limit(page_size).offset(page_size*(current_page-1))
      end

      def get_promotion_designers c_id, page_size, current_page
        phone_numbers = Pandora::Models::PromotionLog.select(:phone_number).where(c_id: c_id).uniq
        user_ids = Pandora::Models::User.select(:id).where(phone_number: phone_numbers)
        Pandora::Models::Designer.non_vip.where(user_id: user_ids).order("created_at desc").limit(page_size).offset(page_size*(current_page-1))
      end

      def get_promotion_vip_designers c_id, page_size, current_page
        phone_numbers = Pandora::Models::PromotionLog.select(:phone_number).where(c_id: c_id).uniq
        user_ids = Pandora::Models::User.select(:id).where(phone_number: phone_numbers)
        Pandora::Models::Designer.vip.where(user_id: user_ids).order("created_at desc").limit(page_size).offset(page_size*(current_page-1))
      end

      def get_shop_promotion_logs c_id, shop_id, page_size, current_page
        Pandora::Models::ShopPromotionLog.where(c_id: c_id, shop_id: shop_id).order("created_at desc").limit(page_size).offset(page_size*(current_page-1))
      end

      def get_shop_all_promotion_logs shop_id, page_size, current_page
        Pandora::Models::ShopPromotionLog.where(shop_id: shop_id).order("created_at desc").limit(page_size).offset(page_size*(current_page-1))
      end

      def add_shop_promotion_log c_id, shop_id, content
        Pandora::Models::ShopPromotionLog.create!(shop_id: shop_id, c_id: c_id, content: content)
      end

      def get_commissioner_QR_code c_id
        Pandora::Models::Commissioner.find(c_id).code_image.url
      end

      def delete_shop shop_id
        Pandora::Models::Shop.active.find(shop_id).update(deleted: true)
      end

      def register_shop name, address, longitude, latitude, scale, category, desc, image_paths, shop_images_folder, province, city
        shop = Pandora::Models::Shop.create!(name: name, address: address, longitude: longitude, latitude: latitude, scale: scale, category: category, desc: desc, province: province, city: city)
        image_paths.each_with_index do |path, index|
          image_path = move_image_to path[:image_path], shop_images_folder
          image = Pandora::Models::Image.create!(category: 'twitter', url: image_path)
          s_image_path = move_image_to path[:s_image_path], shop_images_folder
          s_image = Pandora::Models::Image.create!(category: 'twitter', url: s_image_path, original_image: image)
          Pandora::Models::ShopImage.create!(shop_id: shop.id, image: image)
        end
        shop
      end

      def update_shop shop_id, scale, category, desc, image_paths, shop_images_folder
        shop = Pandora::Models::Shop.find(shop_id)
        shop.update!(scale: scale, category: category, desc: desc)
        image_paths.each_with_index do |path, index|
          image_path = move_image_to path[:image_path], shop_images_folder
          image = Pandora::Models::Image.create!(category: 'twitter', url: image_path)
          s_image_path = move_image_to path[:s_image_path], shop_images_folder
          s_image = Pandora::Models::Image.create!(category: 'twitter', url: s_image_path, original_image: image)
          Pandora::Models::ShopImage.create!(shop_id: shop.id, image: image)
        end
        shop
      end

      def shared_twitter_state user_id, twitter_id, channel
        Pandora::Models::SharedTwitter.create!(user_id: user_id, twitter_id: twitter_id, channel: channel)
      end
    end
  end
end
