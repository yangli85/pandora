require 'pandora/common/logging'
require 'pandora/models/sms_code'

module Pandora
  module Services
    class SMSService
      include Pandora::Common::Logging

      def send message, phone_number
        logger.info("Send #{message} to #{phone_number} successfully!")
      end

      def update_code phone_number, code
        sms_code = Pandora::Models::SMSCode.find_or_create_by(phone_number: phone_number)
        sms_code.code = code
        sms_code.save!
      end

      def get_latest_code phone_number
        Pandora::Models::SMSCode.find_by_phone_number(phone_number)
      end
    end
  end
end