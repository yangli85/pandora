require 'pandora/models/base'
require 'pandora/common/time_helper'

module Pandora
  module Models
    class Message < Pandora::Models::Base
      include Pandora::Common::TimeHelper
      belongs_to :user
      validates :user_id, :presence => true

      def attributes
        {
            id: id,
            content: content,
            created_at: relative_time(created_at),
            is_new: is_new
        }
      end
    end


  end
end

