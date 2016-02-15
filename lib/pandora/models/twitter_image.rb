require 'pandora/models/base'

module Pandora
  module Models
    class TwitterImage < Pandora::Models::Base
      validates :rank, :presence => true
      belongs_to :twitter
      belongs_to :s_image, class_name: "Pandora::Models::Image"
      belongs_to :image, class_name: "Pandora::Models::Image"
    end
  end
end

