require 'pandora/models/base'

module Pandora
  module Models
    class AccountLog < Pandora::Models::Base
      enum events: [:donate, :recharge, :consume, :unknow]
      enum channels: [:alipay, :wechat, :beautyshow]
      validates :event, inclusion: {in: events.keys}
      validates :channel, inclusion: {in: channels.keys}
      belongs_to :account, class_name: "Pandora::Models::Account"
    end
  end
end

