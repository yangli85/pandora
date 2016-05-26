require 'pandora/models/user'
require 'pandora/models/designer'
require 'pandora/models/vita'
require 'pandora/models/vita_image'
require 'pandora/models/image'
require 'pandora/models/favorite_designer'
require 'pandora/common/service_helper'

module Pandora
  module Services
    class DesignerService
      include Pandora::Common::ServiceHelper

      def get_ordered_designers page_size, current_page, order_by
        Pandora::Models::Designer.order("#{order_by} desc").order("created_at asc").limit(page_size).offset((current_page-1)*page_size)
      end

      def get_designer designer_id
        begin
          Pandora::Models::Designer.find(designer_id)
        rescue => e
        end
      end

      def create_designer user_id
        Pandora::Models::Designer.create!(user_id: user_id)
      end

      def get_designer_twitters designer_id, page_size, current_page
        designer = Pandora::Models::Designer.find_by_id(designer_id)
        designer.twitters.active.order("created_at desc").limit(page_size).offset((current_page-1)*page_size) unless designer.nil?
      end

      def get_designer_vitae designer_id, page_size, current_page
        designer = Pandora::Models::Designer.find_by_id(designer_id)
        designer.vitae.order("created_at desc").limit(page_size).offset((current_page-1)*page_size) unless designer.nil?
      end

      def delete_designer_vitae vita_ids
        Pandora::Models::Vita.where(id: vita_ids).destroy_all
      end

      def create_vita designer_id, image_paths, desc, vita_image_folder
        designer =Pandora::Models::Designer.find(designer_id)
        vita = Pandora::Models::Vita.create!(designer: designer, desc: desc)
        image_paths.each do |path|
          image_path = move_image_to path[:image_path], vita_image_folder
          image = Pandora::Models::Image.create!(category: 'vita', url: image_path)
          s_image_path = move_image_to path[:s_image_path], vita_image_folder
          s_image = Pandora::Models::Image.create!(category: 'vita', original_image: image, url: s_image_path)
          Pandora::Models::VitaImage.create!(image: image, vita: vita)
        end
      end

      def search_designers page_size, current_page, query
        users = Pandora::Models::User.where("name like ? or phone_number like ?", "%#{query}%", "%#{query}%")
        Pandora::Models::Designer.where(user: users).order('totally_stars desc').order("created_at asc").limit(page_size).offset((current_page-1)*page_size)
      end

      def get_designer_rank designer_id, order_by
        designer = Pandora::Models::Designer.find(designer_id)
        Pandora::Models::Designer.where("#{order_by} > ? or (#{order_by} = ? and created_at < ?)", designer.send(order_by.to_sym), designer.send(order_by.to_sym), designer.created_at).count + 1
      end

      def get_designer_shop designer_id
        Pandora::Models::Designer.find(designer_id).shop
      end

      def get_customers designer_id, page_size, current_page
        Pandora::Models::Designer.find(designer_id).users.order("name asc").limit(page_size).offset((current_page-1)*page_size)
      end

      def search_customers designer_id, query, page_size, current_page
        Pandora::Models::Designer.find(designer_id).users.where("name like ? or phone_number like ?", "%#{query}%", "%#{query}%").order("vitality desc").limit(page_size).offset((current_page-1)*page_size)
      end

      def update_shop designer_id, shop_id
        designer = Pandora::Models::Designer.find(designer_id)
        designer.update(shop_id: shop_id)
      end

      def delete_twitter designer_id, twitter_id
        Pandora::Models::Twitter.where(designer: designer_id, id: twitter_id).update_all(deleted: true)
      end

      def update_designer designer_id, column, value
        designer = Pandora::Models::Designer.find designer_id
        designer.update(column.to_sym => value)
      end

      def get_new_designer
        Pandora::Models::Designer.vip.order("created_at desc").first
      end

      def get_top1_designer order_by
        Pandora::Models::Designer.vip.order("#{order_by} desc").order("created_at desc").first
      end

    end
  end
end
