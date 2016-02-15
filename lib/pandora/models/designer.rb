require 'pandora/models/base'

module Pandora
  module Models
    class Designer < Pandora::Models::Base
      validates :user_id, :presence => true
      belongs_to :user
      belongs_to :shop
    end
  end
end