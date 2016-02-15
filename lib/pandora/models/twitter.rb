require 'pandora/models/base'

module Pandora
  module Models
    class Twitter < Pandora::Models::Base
      validates :author, :presence => true
      validates :designer, :presence => true
      validates :content, :length => {:maximum => 100}
      belongs_to :author, class_name: "Pandora::Models::User", foreign_key: :author
      belongs_to :designer, class_name: "Pandora::Models::User", foreign_key: :designer
      has_many :twitter_images
      has_many :images, through: :twitter_images, foreign_key: :image_id
      has_many :s_images, through: :twitter_images, foreign_key: :s_image_id
    end
  end
end

