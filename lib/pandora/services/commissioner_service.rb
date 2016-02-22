require 'pandora/models/commissioner'
require 'pandora/models/promotion_log'
require 'pandora/models/shop_promotion_log'
require 'pandora/common/service_helper'
require 'pandora/models/image'
require 'pandora/models/user'
require 'pandora/models/designer'
require 'pandora/models/shop'

module Pandora
  module Services
    class CommissionerService
      include Pandora::Common::ServiceHelper

      def get_commissioner phone_number
        Pandora::Models::Commissioner.find_by_phone_number!(phone_number)
      end

      def get_commissioner_by_id id
        Pandora::Models::Commissioner.find(id)
      end

      def register phone_number, name, password, code_image_path, code_image_folder
        image_path = move_image_to code_image_path, code_image_folder
        code_image = Pandora::Models::Image.create!(category: 'QR_code', url: image_path)
        Pandora::Models::Commissioner.create!(phone_number: phone_number, name: name, password: password, code_image: code_image)
      end

      def get_promotion_logs c_id, page_size, current_page
        commissioner = Pandora::Models::Commissioner.find c_id
        commissioner.promotion_logs.order("created_at desc").limit(page_size).offset(page_size*(current_page-1))
      end

      def get_promotion_logs_count c_id
        commissioner = Pandora::Models::Commissioner.find c_id
        commissioner.promotion_logs.count
      end

      def update_promotion_log log_id, phone_number
        Pandora::Models::PromotionLog.find(log_id).update(phone_number: phone_number)
      end

      def add_promotion_log c_id, user_phone_number, mobile_type
        Pandora::Models::PromotionLog.create!(c_id: c_id, phone_number: user_phone_number, mobile_type: mobile_type)
      end

      def get_promotion_users c_id
        phone_numbers = Pandora::Models::PromotionLog.select(:phone_number).where(c_id: c_id).uniq
        users = Pandora::Models::User.where(phone_number: phone_numbers)
      end

      def get_promotion_designers c_id
        phone_numbers = Pandora::Models::PromotionLog.select(:phone_number).where(c_id: c_id).uniq
        user_ids = Pandora::Models::User.select(:id).where(phone_number: phone_numbers)
        Pandora::Models::Designer.where(user_id: user_ids)
      end

      def get_shop_promotion_logs c_id, shop_id, page_size, current_page
        Pandora::Models::ShopPromotionLog.where(c_id: c_id, shop_id: shop_id).limit(page_size).offset(page_size*(current_page-1))
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

      def register_shop name, address, longtitude, latitude, scale, category, desc
        Pandora::Models::Shop.create!(name: name, address: address, longtitude: longtitude, latitude: latitude, scale: scale, category: category, desc: desc)
      end
    end
  end
end
