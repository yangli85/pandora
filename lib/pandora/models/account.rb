require 'pandora/models/base'

module Pandora
  module Models
    class Account < Pandora::Models::Base
      has_many :account_logs, class_name: "Pandora::Models::AccountLog"
      belongs_to :user, class_name: "Pandora::Models::User"
      validates :user_id, :presence => true
      validates :user, :presence => true
    end
  end
end

