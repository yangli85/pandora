require 'pandora/models/user'
require 'pandora/models/designer'
require 'pandora/models/vita'
require 'pandora/models/vita_image'
require 'pandora/models/image'

module Pandora
  module Services
    class DesignerService
      def get_ordered_designers page_size, current_page, order_by
        Pandora::Models::Designer.vip.order("#{order_by} desc").limit(page_size).offset((current_page-1)*page_size)
      end

      def get_designer designer_id
        begin
          Pandora::Models::Designer.find(designer_id)
        rescue => e
        end
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

      def create_vita designer_id, image_paths, desc
        designer =Pandora::Models::Designer.find(designer_id)
        vita = Pandora::Models::Vita.create!(designer: designer, desc: desc)
        image_paths.each do |image_path|
          s_image = Pandora::Models::Image.create!(category: 'vita', url: image_path[:s_image_path])
          image = Pandora::Models::Image.create!(category: 'vita', s_image: s_image, url: image_path[:image_path])
          Pandora::Models::VitaImage.create!(image: image, vita: vita)
        end
      end

      def search_designers page_size, current_page, query
        users = Pandora::Models::User.where("name like ? or phone_number like ?", "%#{query}%", "%#{query}%")
        Pandora::Models::Designer.vip.where(user: users).order('totally_stars desc')
      end

      def get_designer_rank designer_id, order_by
        designer = Pandora::Models::Designer.find(designer_id)
        Pandora::Models::Designer.vip.where("#{order_by} > ?", designer.send(order_by.to_sym)).count + 1
      end

      def get_designer_shop designer_id
        Pandora::Models::Designer.find(designer_id).shop
      end

      def get_customers designer_id
        designer = Pandora::Models::Designer.find(designer_id)
        users = designer.twitters.order('created_at desc').first(20).map do |twitter|
          twitter.author
        end.uniq.first(10)
      end

      def update_shop designer_id, shop_id
        designer = Pandora::Models::Designer.find(designer_id)
        designer.update(shop_id: shop_id)
      end

      def delete_twitter designer_id, twitter_id
        Pandora::Models::Twitter.where(designer: designer_id, id: twitter_id).update_all(deleted: true)
      end
    end
  end
end
