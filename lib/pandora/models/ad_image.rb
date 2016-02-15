require 'pandora/models/base'

module Pandora
  module Models
    class AdImage < Pandora::Models::Base
      validates :image_id, :presence => true
      belongs_to :image, class_name: "Pandora::Models::Image"
    end
  end
end

