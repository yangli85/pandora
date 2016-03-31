require 'pandora/models/base'

module Pandora
  module Models
    class Order < Pandora::Models::Base
      enum products: [:VIP, :STAR]
      validates :product, inclusion: {in: products.keys}
      has_one :payment_log
    end
  end
end

