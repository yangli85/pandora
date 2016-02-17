require 'pandora/models/user'
require 'pandora/models/designer'
require 'pandora/models/vita'
require 'pandora/models/vita_image'
require 'pandora/models/image'

module Pandora
  module Services
    class DesignerService
      def get_ordered_designers page_size, current_page, order_by
        Pandora::Models::Designer.where(is_vip: true).order("#{order_by} desc").limit(page_size).offset((current_page-1)*page_size)
      end

      def get_designer_by_user_id user_id
        Pandora::Models::Designer.find_by_user_id(user_id)
      end

      def get_designer_twitters designer_id, page_size, current_page, order_by
        designer = Pandora::Models::Designer.find_by_id(designer_id)
        designer.twitters.order("#{order_by} desc").limit(page_size).offset((current_page-1)*page_size) unless designer.nil?
      end

      def get_designer_vitae designer_id
        designer = Pandora::Models::Designer.find_by_id(designer_id)
        designer.vitae.order("created_at desc") unless designer.nil?
      end

      def delete_designer_vitae vita_ids
        Pandora::Models::Vita.where(id: vita_ids).destroy_all
      end

      def create_vita designer_id, image_paths, desc
        designer =Pandora::Models::Designer.find(designer_id)
        vita = Pandora::Models::Vita.create!(designer: designer, desc: desc)
        image_paths.each do |image_path|
          image = Pandora::Models::Image.create!(category: 'vita', url: image_path)
          Pandora::Models::VitaImage.create!(image: image, vita: vita)
        end
      end

      def search_designers page_size, current_page, query
        users = Pandora::Models::User.where("name like ? or phone_number like ?", "%#{query}%", "%#{query}%")
        Pandora::Models::Designer.where(is_vip: true, user: users).order('totally_stars desc')
      end

      def get_designer_rank designer_id, order_by
        designer = Pandora::Models::Designer.find(designer_id)
        Pandora::Models::Designer.where("#{order_by} > ?", designer.send(order_by.to_sym)).count + 1
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
    end
  end
end
