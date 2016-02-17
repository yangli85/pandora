require 'pandora/models/shop'

module Pandora
  module Services
    class ShopService
      include Math

      def get_vicinal_shop longtitude, latitude, range
        s_lon = longtitude.to_f - range/(cos(radians longtitude)*69).abs
        b_lon = longtitude.to_f + range/(cos(radians longtitude)*69).abs
        s_lat = latitude.to_f - (range/69.to_f)
        b_lat = latitude.to_f + (range/69.to_f)
        sql = <<EOSQL
        SELECT id,
               ( 3959 * ACOS( COS( RADIANS(#{latitude}) )
               * COS( RADIANS( latitude ) )
               * COS( RADIANS( longtitude ) - RADIANS(#{longtitude}) )
               + SIN( RADIANS(#{latitude}) )
               * SIN( RADIANS( latitude ) ) ) ) AS distance
        FROM shops
        WHERE  latitude BETWEEN #{s_lat} AND #{b_lat}
        AND longtitude BETWEEN #{s_lon} AND #{b_lon}
        HAVING distance < #{range} ORDER BY distance;
EOSQL
        Pandora::Models::Shop.find_by_sql(sql)
      end

      def get_shop_designers shop_id
        Pandora::Models::Shop.find(shop_id).designers
      end

      def get_shop shop_id
        Pandora::Models::Shop.find(shop_id)
      end

      def create_shop name, address, latitude, longtitude
        Pandora::Models::Shop.create!(name: name, address: address, latitude: latitude, longtitude: longtitude)
      end

      def search_shops query
        Pandora::Models::Shop.where("name like ?", "%#{query}%")
      end

      private
      def radians degree
        degree.to_f * Math::PI/180
      end
    end
  end
end
