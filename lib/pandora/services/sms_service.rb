require 'pandora/common/logging'

module Pandora
  module Services
    class SmsService
      include Pandora::Common::Logging

      def send message, phone_number
        logger.info("Send #{message} to #{phone_number} successfully!")
      end
    end
  end
end