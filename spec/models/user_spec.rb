require 'spec_helper'
require 'pandora/models/user'
require 'pandora/models/account'

describe Pandora::Models::User do
  let(:user) { create(:user) }

  describe 'has_one account' do
    before do
      create(:account, user: user)
    end

    it 'should get user related account info' do
      expect(user.account).to eq Pandora::Models::Account.find_by_user_id(user.id)
    end
  end

  describe 'validate' do
    context 'error' do
      it 'should raise error if gender is wrong' do
        expect { create(:user, gender: 'wrong') }.to raise_error ActiveRecord::RecordInvalid
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
        expect{create(:user, gender: 'unknow')}.not_to raise_error
      end

      it "shoud create user successfully if phone number is right" do
        expect{create(:user, phone_number: '18723456783')}.not_to raise_error
      end
    end
  end
end