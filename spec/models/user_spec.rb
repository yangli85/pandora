require 'spec_helper'
require 'pandora/models/user'
require 'pandora/models/account'
require 'pandora/models/twitter'
require 'pandora/models/designer'
require 'pandora/models/image'
require 'pandora/models/message'
require 'pandora/models/favorite_image'
require 'pandora/models/favorite_designer'
require 'pandora/models/designer'

describe Pandora::Models::User do
  let(:user) { create(:user) }

  describe 'belongs to image' do
    it "should get user avatar" do
      image = create(:image)
      user_with_avatar = create(:user, {avatar: image, phone_number: '13811223232'})
      expect(user_with_avatar.avatar).to eq image
    end
  end

  describe 'has one account' do
    before do
      create(:account, user: user)
    end

    it 'should get user related account info' do
      expect(user.account).to eq Pandora::Models::Account.find_by_user_id(user.id)
    end
  end

  describe 'has one designer' do

    it 'should return nil if no designer info' do
      expect(user.designer).to eq nil
    end

    it 'should return designer info if has designer info' do
      create(:designer, user: user)
      expect(user.designer).to eq Pandora::Models::Designer.find(user.id)
    end
  end

  describe 'has many twitters' do

    it "should get user's twitters" do
      author1 = create(:user, phone_number: '13811111111')
      author2 = create(:user, phone_number: '13811111112')
      user = create(:user, phone_number: '13811111113')
      designer = create(:designer, user: user)
      twitter1 = create(:twitter, {author: author1, designer: designer})
      twitter2 = create(:twitter, {author: author2, designer: designer})
      expect(author1.twitters.count).to eq 1
    end
  end

  describe 'has many messages' do
    before do
      create(:message, user: user)
      create(:message, user: user)
      create(:message, user: user)
    end

    it "should get user's messages" do
      expect(user.messages.count).to eq 3
    end
  end

  describe 'has many favorite images' do
    before do
      designer = create(:designer, user: user)
      twitter = create(:twitter, {author: user, designer: designer})
      image1 = create(:image)
      image2 = create(:image)
      create(:twitter_image, {twitter: twitter, image: image1})
      create(:twitter_image, {twitter: twitter, image: image2})
      create(:favorite_image, {user: user, favorited_image: image1, twitter: twitter})
      create(:favorite_image, {user: user, favorited_image: image2, twitter: twitter})
    end

    it "should get user's favorite images" do
      expect(user.favorited_images.count).to eq 2
    end
  end

  describe 'has many favorite designers' do
    before do
      user1 = create(:user, phone_number: 13811112222)
      user2 = create(:user, phone_number: 13811113333)
      designer1 = create(:designer, user: user1)
      designer2 = create(:designer, user: user2)
      create(:favorite_designer, {user: user, favorited_designer: designer1})
      create(:favorite_designer, {user: user, favorited_designer: designer2})
    end

    it "should get user's favorite images" do
      expect(user.favorited_designers.count).to eq 2
    end
  end

  describe 'validate' do
    context 'error' do
      it 'should raise error if gender is wrong' do
        expect { create(:user, gender: 'wrong') }.to raise_error ActiveRecord::RecordInvalid
      end

      it 'should raise error if status is wrong' do
        expect { create(:user, status: 'wrong_status') }.to raise_error ActiveRecord::RecordInvalid
      end

      it "should raise error if format of phone number is wrong" do
        expect { create(:user, phone_number: 'wrong') }.to raise_error ActiveRecord::RecordInvalid
        expect { create(:user, phone_number: '13872') }.to raise_error ActiveRecord::RecordInvalid
        expect { create(:user, phone_number: '2511111111111') }.to raise_error ActiveRecord::RecordInvalid
      end

      it "should raise error if phonenumber is nil" do
        expect { create(:user, phone_number: nil) }.to raise_error ActiveRecord::RecordInvalid
      end

      it "should raise error if phonenuber is not unique" do
        create(:user, phone_number: '13811768232')
        expect { create(:user, phone_number: '13811768232') }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context 'success' do
      it "shoud create user successfully if gender is right" do
        expect { create(:user, gender: 'unknow') }.not_to raise_error
      end

      it "shoud create user successfully if phone number is right" do
        expect { create(:user, phone_number: '18723456783') }.not_to raise_error
      end
    end
  end

  describe "dependent to" do
    before do
      avatar = create(:image)
      s_avatar = create(:image, original_image: avatar)
      user.update(avatar: avatar)
    end

    it "should delete user's avatar if user deleted" do
      user.destroy
      expect(Pandora::Models::Image.count).to eq 0
    end
  end
end