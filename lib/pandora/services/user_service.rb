require 'pandora/models/account'
require 'pandora/models/account_log'
require 'pandora/models/message'
require 'pandora/models/image'
require 'pandora/models/favorite_image'
require 'pandora/models/favorite_designer'
require 'pandora/models/designer'
require 'pandora/models/user'
require 'pandora/common/service_helper'

module Pandora
  module Services
    class UserService
      include Pandora::Common::ServiceHelper

      def get_user_by_phone_number phone_number
        Pandora::Models::User.find_by_phone_number(phone_number)
      end

      def get_user_by_id id
        Pandora::Models::User.find(id)
      end

      def create_user phone_number
        user = Pandora::Models::User.create!(name: phone_number, phone_number: phone_number)
        Pandora::Models::Account.create!(user: user)
        user
      end

      def update_user_profile user_id, column, value
        user = Pandora::Models::User.find(user_id)
        user.update(column.to_sym => value)
      end

      def update_user_avatar user_id, image_path, avatar_image_folder
        user = Pandora::Models::User.find(user_id)
        original_image_path = move_image_to image_path[:image_path], avatar_image_folder
        avatar = Pandora::Models::Image.create!(category: 'twitter', url: original_image_path)
        s_image_path = move_image_to image_path[:s_image_path], avatar_image_folder
        s_image = Pandora::Models::Image.create!(category: 'twitter', original_image: avatar, url: s_image_path)
        user.update(avatar: avatar)
      end

      def add_favorite_image user_id, image_id
        user = Pandora::Models::User.find(user_id)
        image = Pandora::Models::Image.find(image_id)
        Pandora::Models::FavoriteImage.create!(user: user, favorited_image: image)
      end

      def del_favorite_images ids
        Pandora::Models::FavoriteImage.where(id: ids).destroy_all
      end

      def favorited_image? user_id, image_id
        Pandora::Models::FavoriteImage.where(user_id: user_id, image_id: image_id).empty? ? false : true
      end

      def favorited_images user_id
        Pandora::Models::User.find(user_id).favorite_images
      end

      def del_favorite_image user_id, image_id
        Pandora::Models::FavoriteImage.where(user_id: user_id, image_id: image_id).destroy_all
      end

      def add_favorite_designer user_id, designer_id
        user = Pandora::Models::User.find(user_id)
        designer = Pandora::Models::Designer.find(designer_id)
        Pandora::Models::FavoriteDesigner.create!(user: user, favorited_designer: designer)
      end

      def favorited_designer? user_id, designer_id
        Pandora::Models::FavoriteDesigner.where(user_id: user_id, designer_id: designer_id).empty? ? false : true
      end

      def favorited_designers user_id
        Pandora::Models::User.find(user_id).favorite_designers
      end

      def del_favorite_designers ids
        Pandora::Models::FavoriteDesigner.where(id: ids).destroy_all
      end

      def get_user_twitters user_id, page_size, current_page
        Pandora::Models::User.find(user_id).twitters.order("created_at desc").limit(page_size).offset((current_page-1)*page_size)
      end

      def delete_twitter author_id, twitter_id
        Pandora::Models::Twitter.where(author: author_id, id: twitter_id).destroy_all
      end

      def get_account user_id
        Pandora::Models::User.find(user_id).account
      end

      def update_account_balance account_id, balance, desc, from_user, to_user, event, channel
        account = Pandora::Models::Account.find(account_id)
        account.update(balance: account.balance + balance)
        Pandora::Models::AccountLog.create!(account: account, event: event, from_user: from_user, to_user: to_user, desc: desc, balance: balance, channel: channel)
      end

      def get_account_logs user_id, page_size, current_page
        Pandora::Models::User.find(user_id).account.account_logs.order("created_at desc").limit(page_size).offset((current_page-1)*page_size)
      end

      def add_account_log account_id, event, channel, balance, from_user, to_user, desc
        account = Pandora::Models::Account.find(account_id)
        account_log = Pandora::Models::AccountLog.create(account: account)
        account_log.event = event
        account_log.channel = channel
        account_log.balance = balance
        account_log.from_user = from_user
        account_log.to_user = to_user
        account_log.desc = desc
        account_log.save!
      end

      def get_new_messages_count user_id
        Pandora::Models::User.find(user_id).messages.where(is_new: true).count
      end

      def update_messages user_id
        Pandora::Models::Message.where(user_id: user_id).update_all(is_new: false)
      end

      def get_messages user_id
        Pandora::Models::User.find(user_id).messages.order("created_at desc")
      end

      def delete_message message_id
        Pandora::Models::Message.find(message_id).destroy
      end

      def create_message user_id, content
        Pandora::Models::Message.create!(user_id: user_id, content: content)
      end

      def search_users query
        Pandora::Models::User.where("name like ? or phone_number like ?", "%#{query}%", "%#{query}%")
      end
    end
  end
end