require 'spec_helper'
require 'pandora/models/account'
require 'pandora/models/account_log'
require 'pandora/models/user'

describe Pandora::Models::AccountLog do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:account_log) { create(:account_log, {account: account, from_user: user.id, to_user: user.id, event: 'RECHARGE'}) }


  describe 'belong to' do
    it "should get related account info by account log" do
      expect(account_log.account).to eq account
    end
  end
end