require 'pandora/models/base'

module Pandora
  module Models
    class VitaImage < Pandora::Models::Base
      validates :image_id, :uniqueness => true, :presence => true
      belongs_to :vita
      belongs_to :image, dependent: :destroy
      validates :vita_id, :presence => true
    end
  end
end

