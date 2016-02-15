require 'spec_helper'
require 'pandora/models/account'
require 'pandora/models/account_log'

describe Pandora::Models::Account do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }

  describe 'belong to' do
    it "should get related user info by account" do
      expect(account.user).to eq user
    end
  end

  describe 'has_many' do
    before do
      5.times do
        create(:account_log, {account: account, from_user: user.id, to_user: user.id, event: 'recharge'})
      end
    end

    it "should get account log by account" do
      expect(account.account_logs.size).to eq 5
    end
  end

  describe 'valiadte' do
    it "should raise error if user_id is nil" do
      expect { create(:account, user_id: nil) }.to raise_error ActiveRecord::RecordInvalid
    end

    it "should raise error if user_id is invalide" do
      expect { create(:account, user_id: 'not exist user') }.to raise_error StandardError
    end
  end
end