require 'pandora/models/base'

module Pandora
  module Models
    class LoginUser < Pandora::Models::Base
      belongs_to :user, class_name: "Pandora::Models::User"
      validates :user_id, :presence => true
      validates :user, :presence => true
    end
  end
end

