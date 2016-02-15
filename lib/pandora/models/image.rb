require 'pandora/models/base'

module Pandora
  module Models
    class Image < Pandora::Models::Base
      enum categories: [:avatar, :twitter, :vita, :ad, :unknow]
      validates :category, inclusion: {in: categories.keys}
      validates :url, :presence => true
    end
  end
end

