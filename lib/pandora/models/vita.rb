require 'pandora/models/base'
require 'pandora/common/time_helper'

module Pandora
  module Models
    class Vita < Pandora::Models::Base
      include Pandora::Common::TimeHelper
      self.table_name="vitae"
      has_many :vita_images, dependent: :destroy
      has_many :images, through: :vita_images, foreign_key: :image_id
      belongs_to :designer
      validates :designer_id, :presence => true

      def attributes
        {
            id: id,
            desc: desc,
            images: images.map(&:attributes),
            created_at: relative_time(created_at)
        }
      end
    end
  end
end

