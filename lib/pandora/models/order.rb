require 'pandora/models/base'

module Pandora
  module Models
    class Order < Pandora::Models::Base
      enum products: [:VIP, :STAR]
      validates :product, inclusion: {in: products.keys}
      has_one :payment_log

      def attributes
        {
            id: id,
            product: product,
            count: count,
            status: status,
            total_fee: total_fee,
            result: result
        }
      end
    end
  end
end

