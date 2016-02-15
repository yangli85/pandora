require 'pandora/models/user'
module Pandora
  module Services
    class UserService
      def get_user phone_number
        Pandora::Models::User.find_by_phone_number(phone_number)
      end

      def create_user phone_number
        user = Pandora::Models::User.create!(name: phone_number, phone_number: phone_number)
        Pandora::Models::Account.create!(user: user)
        user
      end
    end
  end
end
