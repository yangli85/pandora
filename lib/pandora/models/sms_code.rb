require 'pandora/models/base'

module Pandora
  module Models
    class SMSCode < Pandora::Models::Base
      validates :phone_number, :presence => true
      validates :code, :presence => true
    end
  end
end

