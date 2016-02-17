require 'pandora/models/base'

module Pandora
  module Models
    class Vita < Pandora::Models::Base
      self.table_name="vitae"
      has_many :vita_images, dependent: :destroy
      has_many :images, through: :vita_images, foreign_key: :image_id
      belongs_to :designer
      validates :designer_id, :presence => true
    end
  end
end

