require 'spec_helper'
require 'pandora/models/user'
require 'pandora/models/account'
require 'pandora/models/twitter'
require 'pandora/models/designer'
require 'pandora/models/image'

describe Pandora::Models::User do
  let(:user) { create(:user) }

  describe 'belongs to image' do
    it "should get avatar image info" do
      image = create(:image)
      user_with_avatar = create(:user, {image: image, phone_number: '13811223232'})
      expect(user_with_avatar.image).to eq image
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

    it "should get author's twitters" do
      author = create(:user, phone_number: '13811111111')
      designer = create(:user, phone_number: '13822222222')
      twitter1 = create(:twitter, {author: author, designer: designer})
      twitter2 = create(:twitter, {author: designer, designer: author})
      expect(author.my_twitters.count).to eq 1
      expect(author.my_twitters.first.author).to eq author
    end

    it "should get author's twitters" do
      author = create(:user, phone_number: '13811111111')
      designer = create(:user, phone_number: '13822222222')
      twitter1 = create(:twitter, {author: author, designer: designer})
      twitter2 = create(:twitter, {author: designer, designer: author})
      expect(author.related_twitters.count).to eq 1
      expect(author.related_twitters.first.designer).to eq author
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
end