require 'pandora/models/base'

module Pandora
  module Models
    class Image < Pandora::Models::Base
      enum types: [:avatar, :twitter, :vita, :unknow]
      validates :type, inclusion: {in: types.keys}
      validates :url, :presence => true
    end
  end
end

