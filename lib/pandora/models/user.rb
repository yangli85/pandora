require 'pandora/models/base'

module Pandora
  module Models
    class User < Pandora::Models::Base
      enum genders: [:male, :female, :unknow]
      enum statuses: [:nomal,:black]
      validates :gender, inclusion: {in: genders.keys}
      validates :status, inclusion: {in: statuses.keys}
      validates :phone_number, :uniqueness => true, :format => {:with => /\A[\d]{11}\z/}
      has_one :account, class_name: "Pandora::Models::Account"
      has_many :my_twitters, class_name: "Pandora::Models::Twitter", foreign_key: :author
      has_many :related_twitters, class_name: "Pandora::Models::Twitter", foreign_key: :designer
      has_one :designer
      belongs_to :image
    end
  end
end

