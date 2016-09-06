require 'pandora/models/base'

module Pandora
  module Models
    class SharedTwitter < Pandora::Models::Base
      enum channels: [:WX, :WB, :QQ]
      validates :channel, inclusion: {in: channels.keys}
      validates :twitter_id, :presence => true
      validates :user_id, :presence => true
      belongs_to :twitter, class_name: "Pandora::Models::Twitter", foreign_key: :twitter_id, dependent: :destroy
      belongs_to :user, class_name: "Pandora::Models::User", foreign_key: :user_id, dependent: :destroy

      def attributes
        {
            id: id,
            twitter_id: twitter_id,
            user_id: user_id
        }
      end
    end
  end
end

