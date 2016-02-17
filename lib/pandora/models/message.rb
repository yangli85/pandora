require 'pandora/models/base'

module Pandora
  module Models
    class Message < Pandora::Models::Base
      belongs_to :user
      validates :user_id, :presence => true
    end
  end
end

