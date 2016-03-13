require 'pandora/models/shop'

module Pandora
  module Services
    class ShopService
      include Math

      def get_vicinal_shops longitude, latitude, range
        s_lon = longitude.to_f - range/(cos(radians longitude)*69).abs
        b_lon = longitude.to_f + range/(cos(radians longitude)*69).abs
        s_lat = latitude.to_f - (range/69.to_f)
        b_lat = latitude.to_f + (range/69.to_f)
        sql = <<EOSQL
        SELECT id,
               ( 3959 * ACOS( COS( RADIANS(#{latitude}) )
               * COS( RADIANS( latitude ) )
               * COS( RADIANS( longitude ) - RADIANS(#{longitude}) )
               + SIN( RADIANS(#{latitude}) )
               * SIN( RADIANS( latitude ) ) ) ) AS distance
        FROM shops
        WHERE  deleted = false
        AND latitude BETWEEN #{s_lat} AND #{b_lat}
        AND longitude BETWEEN #{s_lon} AND #{b_lon}
        HAVING distance < #{range} ORDER BY distance;
EOSQL
        Pandora::Models::Shop.find_by_sql(sql)
      end

      def get_shop_designers shop_id
        Pandora::Models::Shop.active.find(shop_id).designers
      end

      def get_shop shop_id
        Pandora::Models::Shop.find(shop_id)
      end

      def create_shop name, address, latitude, longitude, province, city
        Pandora::Models::Shop.active.create!(name: name, address: address, latitude: latitude, longitude: longitude, province: province, city: city)
      end

      def search_shops query, page_size, current_page, order_by
        Pandora::Models::Shop.active.where("name like ?", "%#{query}%").order("#{order_by} desc").limit(page_size).offset(page_size*(current_page-1))
      end

      def search_shops_by_name name
        Pandora::Models::Shop.active.where("name like ?", "%#{name}%").order("created_at desc")
      end

      def shops page_size, current_page, order_by
        Pandora::Models::Shop.active.order("#{order_by} desc").limit(page_size).offset(page_size*(current_page-1))
      end

      def get_similar_shops name, address, longitude, latitude
        Pandora::Models::Shop.active.where("name like ? and address like ? and abs(latitude - #{latitude}) <0.05 and abs(longitude - #{longitude}) <0.05", "%#{name}%", "%#{address}%")
      end

      private
      def radians degree
        degree.to_f * Math::PI/180
      end
    end
  end
end
