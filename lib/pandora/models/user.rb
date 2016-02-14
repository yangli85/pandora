require 'pandora/models/base'

module Pandora
  module Models
    class User < Pandora::Models::Base
      enum genders: [:male, :female, :unknow]
      validates :gender, inclusion: {in: genders.keys}
      validates :phone_number, :uniqueness => true, :format => {:with => /\A[\d]{11}\z/}
      has_one :account, class_name: "Pandora::Models::Account"
    end
  end
end

