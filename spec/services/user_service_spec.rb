require 'pandora/services/user_service'

describe Pandora::Services::UserService do
  let(:fake_phone_number) { "13812345678" }

  describe "#get_user" do
    it "should get user info by given phone_number" do
      user = create(:user, phone_number: fake_phone_number)
      expect(subject.get_user fake_phone_number).to eq user
    end
  end

  describe "#create_user" do
    it "should create a user for given phone_number" do
      new_user = subject.create_user fake_phone_number
      expect(new_user.phone_number).to eq fake_phone_number
      expect(new_user.name).to eq fake_phone_number
      expect(new_user.gender).to eq 'unknow'
      expect(new_user.vitality).to eq 0
    end

    it "should create user account" do
      user = subject.create_user fake_phone_number
      account = user.account
      expect(account.user_id).to eq user.id
      expect(account.balance).to eq 0
    end
  end
end