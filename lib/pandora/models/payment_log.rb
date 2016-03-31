require 'pandora/models/base'

module Pandora
  module Models
    class PaymentLog < Pandora::Models::Base
      belongs_to :order, class_name: "Pandora::Models::Order"
      validates :order, :presence => true
      validates :order_id, :uniqueness => true
    end
  end
end

