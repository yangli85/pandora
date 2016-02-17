require 'pandora/services/user_service'
require 'pandora/models/twitter'
require 'pandora/models/account_log'

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

  describe "#update_user_profile" do
    it "should update user name" do
      user = create(:user)
      subject.update_user_profile user.id, 'name', 'new name'
      expect(Pandora::Models::User.find(user.id).name).to eq 'new name'
    end

    it "should update user image" do
      user = create(:user)
      image = create(:image)
      subject.update_user_profile user.id, 'image_id', image.id
      expect(Pandora::Models::User.find(user.id).image_id).to eq image.id
    end
  end

  describe 'favorite images' do
    let(:image) { create(:image) }
    let(:user) { create(:user) }

    describe "#add_favorite_image" do
      it "should add user favorite image successfully" do
        subject.add_favorite_image user.id, image.id
        expect(user.favorited_images.count).to eq 1
      end
    end

    describe "#del_favorite_images" do
      let(:favorite_image) { create(:favorite_image, {user: user, favorited_image: image}) }

      it "should delete user favorite image if give a favorite image id" do
        subject.del_favorite_images favorite_image.id
        expect(user.favorited_images.count).to eq 0
      end

      it "should delete user favorite image if give a favorite images id list" do
        subject.del_favorite_images [favorite_image.id]
        expect(user.favorited_images.count).to eq 0
      end
    end


    describe "#favorited_image?" do
      it "should return false if user has not favorited the image" do
        expect(subject.favorited_image? user.id, image.id).to eq false
      end

      it "should return true if user has not favorited the image" do
        subject.add_favorite_image user.id, image.id
        expect(subject.favorited_image? user.id, image.id).to eq true
      end
    end

    describe "#favorited_images" do
      it "should return user favorited images" do
        subject.add_favorite_image user.id, image.id
        expect(subject.favorited_images(user.id).count).to eq 1
      end

      it "should return [] if user has no favorited images" do
        expect(subject.favorited_images(user.id)).to eq []
      end
    end
  end

  describe 'favorite designers' do
    let(:user) { create(:user) }
    let(:designer) { create(:designer, user: user) }

    describe "#add_favorite_designer" do
      it "should add user favorite designer successfully" do
        subject.add_favorite_designer user.id, designer.id
        expect(user.favorited_designers.count).to eq 1
      end
    end

    describe "#favorited_designer?" do
      it "should return false if user has not favorited the designer" do
        expect(subject.favorited_designer? user.id, designer.id).to eq false
      end

      it "should return true if user has not favorited the designer" do
        subject.add_favorite_designer user.id, designer.id
        expect(subject.favorited_designer? user.id, designer.id).to eq true
      end
    end

    describe "#favorited_designers" do
      it "should return user favorited designers" do
        subject.add_favorite_designer user.id, designer.id
        expect(subject.favorited_designers(user.id).count).to eq 1
      end

      it "should return [] if user has no favorited designers" do
        expect(subject.favorited_designers(user.id)).to eq []
      end
    end

    describe "#del_favorite_designers" do
      let(:new_user) { create(:user, phone_number: '13812342345') }
      let(:new_designer) { create(:designer, user: new_user) }

      before do
        create(:favorite_designer, {user: user, favorited_designer: designer})
        create(:favorite_designer, {user: user, favorited_designer: new_designer})
      end

      it "should delete user favorite designer if give a favorite designer id" do
        subject.del_favorite_designers user.favorite_designers.first.id
        expect(user.favorited_designers.count).to eq 1
      end

      it "should delete user favorite designer if give a favorite designers id list" do
        subject.del_favorite_designers user.favorite_designers.map(&:id)
        expect(user.favorited_designers.count).to eq 0
      end
    end
  end

  describe "user twitters" do
    let(:author) { create(:user, phone_number: fake_phone_number) }
    let(:designer) { create(:designer, user: author) }

    before do
      create(:twitter, {author: author, designer: designer})
      create(:twitter, {author: author, designer: designer})
      create(:twitter, {author: author, designer: designer})
      create(:twitter, {author: author, designer: designer, deleted: true})
    end

    describe "#get_user_twitters" do
      it "should return user's all undeleted twitters" do
        expect(subject.get_user_twitters(author.id, 3, 1).count).to eq 3
        expect(subject.get_user_twitters(author.id, 3, 2).count).to eq 0
        expect(subject.get_user_twitters(author.id, 2, 2).count).to eq 1
      end

      it "should return all undeleted twitters" do
        expect(subject.get_user_twitters(author.id, 5, 1).all? { |t| !t.deleted }).to eq true
      end
    end

    describe "#delete_twitter" do
      it "should delete user's twitter" do
        subject.delete_twitter(author.id, author.twitters.first.id)
        expect(author.twitters.count).to eq 2
      end

      it "should not delete if the user is not the twitter's author" do
        subject.delete_twitter(100, author.twitters.first.id)
        expect(author.twitters.count).to eq 3
      end
    end
  end

  describe "#get_account" do
    let(:user) { create(:user, phone_number: fake_phone_number) }

    before do
      create(:account, user: user)
    end

    it "should return user's account info" do
      account = subject.get_account user.id
      expect(account.user_id).to eq user.id
    end
  end

  describe "#update_account_balance" do
    it "should update account balance + 10" do
      user = create(:user)
      account = Pandora::Models::Account.create(user: user)
      old_balance = account.balance
      subject.update_account_balance account.id, 10
      expect(Pandora::Models::Account.find(account.id).balance - old_balance).to eq 10
    end

    it "should update account balance - 10" do
      user = create(:user)
      account = Pandora::Models::Account.create(user: user)
      old_balance = account.balance
      subject.update_account_balance account.id, -10
      expect(Pandora::Models::Account.find(account.id).balance - old_balance).to eq -10
    end
  end

  describe "#get_account_logs" do
    let(:user) { create(:user, phone_number: fake_phone_number) }
    let(:account) { create(:account, user: user) }

    before do
      5.times do
        create(:account_log, {account: account, from_user: user.id, to_user: user.id, event: 'recharge'})
      end
    end

    it "should return all accout's logs" do
      expect(subject.get_account_logs(user.id).count).to eq 5
    end

    it "should order by created_at" do
      expect(subject.get_account_logs(user.id).each_cons(2).all? { |l1, l2| l1.created_at >= l2.created_at }).to eq true
    end
  end

  describe "#add_account_log" do
    let(:user) { create(:user, phone_number: fake_phone_number) }
    let(:account) { create(:account, user: user) }

    it "should create account log successfully" do
      subject.add_account_log(account.id, 'recharge', 'alipay', '10', user.id, user.id, "buy 10 stars")
      account_log = account.account_logs.first
      expect(account_log.channel).to eq "alipay"
      expect(account_log.balance).to eq 10
      expect(account_log.from_user).to eq user.id
      expect(account_log.to_user).to eq user.id
      expect(account_log.desc).to eq "buy 10 stars"
    end
  end

  describe "message" do
    let(:user) { create(:user) }

    before do
      create(:message, user: user)
      create(:message, user: user)
      create(:message, {user: user, is_new: false})
      create(:message, user: user)
    end

    describe "#get_new_messages_count" do
      it "should return all user's new messages's count" do
        expect(subject.get_new_messages_count(user.id)).to eq 3
      end
    end

    describe "#update_messages" do
      it "should update all user's messages to be read" do
        subject.update_messages user.id
        expect(user.messages.where(is_new: true).count).to eq 0
      end
    end

    describe "#get_messages" do
      it "should return all user's new messages" do
        expect(subject.get_messages(user.id).count).to eq 4
      end
    end

    describe "#delete_message" do
      it "should delete message" do
        subject.delete_message(user.messages.first.id)
        expect(user.messages.count).to eq 3
      end
    end

    describe "#search_users" do
      before do
        create(:user, {name: 'Jun Han', phone_number: '13800000001'})
        create(:user, {name: 'Jun Wei', phone_number: '13800000002'})
        create(:user, {name: 'Jun Li', phone_number: '13800000003'})
      end

      it "should search user" do
        expect(subject.search_users('Jun').count).to eq 3
        expect(subject.search_users('Han').count).to eq 1
        expect(subject.search_users('13800000001').count).to eq 1
        expect(subject.search_users('138').count).to eq 3
      end
    end
  end
end