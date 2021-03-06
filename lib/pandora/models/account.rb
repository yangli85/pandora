require 'pandora/models/base'

module Pandora
  module Models
    class Account < Pandora::Models::Base
      has_many :account_logs, class_name: "Pandora::Models::AccountLog", dependent: :destroy
      belongs_to :user, class_name: "Pandora::Models::User"
      validates :user_id, :presence => true
      validates :user, :presence => true
      validates :user_id, :uniqueness => true
    end
  end
end

