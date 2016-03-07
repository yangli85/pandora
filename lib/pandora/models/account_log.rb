require 'pandora/models/base'
require 'pandora/common/time_helper'

module Pandora
  module Models
    class AccountLog < Pandora::Models::Base
      include Pandora::Common::TimeHelper
      enum events: [:donate, :recharge, :consume, :unknow]
      enum channels: [:alipay, :wechat, :beautyshow]
      validates :event, inclusion: {in: events.keys}
      validates :channel, inclusion: {in: channels.keys}
      belongs_to :account, class_name: "Pandora::Models::Account"

      def attributes
        {
            id: id,
            desc: desc,
            balance: balance,
            created_at: relative_time(created_at)
        }
      end
    end
  end
end

