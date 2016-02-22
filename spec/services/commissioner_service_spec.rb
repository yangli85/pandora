require 'pandora/services/commissioner_service'

describe Pandora::Services::CommissionerService do
  let(:fake_phone_number) { "18611979882" }
  let(:commissioner) { create(:commissioner, phone_number: fake_phone_number) }

  before do
    commissioner
  end

  describe "#get_commissioner" do
    it "should get commissioner by phone_number" do
      expect(subject.get_commissioner fake_phone_number).to eq commissioner
    end
  end

  describe "#get_commissioner_by_id" do
    it "should get commissioner by id" do
      expect(subject.get_commissioner_by_id commissioner.id).to eq commissioner
    end
  end

  describe "#register" do
    let(:fake_name) { "new commissioner" }
    let(:fake_password) { "111111" }
    let(:fake_image) { create(:image) }
    let(:fake_image_folder) { 'temp_images/code' }

    before do
      commissioner.destroy
      allow(FileUtils).to receive(:mv)
    end

    it "should create commissioner" do
      new_commissioner = subject.register fake_phone_number, fake_name, fake_password, fake_image.url, fake_image_folder
      expect(new_commissioner).to eq Pandora::Models::Commissioner.find_by_phone_number(fake_phone_number)
    end

    it "should create commissioner with correct attibutes" do
      new_commissioner = subject.register fake_phone_number, fake_name, fake_password, fake_image.url, fake_image_folder
      expect(new_commissioner.name).to eq fake_name
      expect(new_commissioner.phone_number).to eq fake_phone_number
      expect(new_commissioner.password).to eq fake_password
      expect(new_commissioner.code_image.url).to eq 'temp_images/code/1.jpg'
    end

    context "raise error" do
      it "should raise error if phone_number is nil" do
        expect { subject.register(nil, fake_name, fake_password, fake_image.url, fake_image_folder) }.to raise_error ActiveRecord::RecordInvalid
      end

      it "should raise error if password longer than 10" do
        expect { subject.register(fake_phone_number, fake_name, 'longpassword', fake_image.url, fake_image_folder) }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe "commissioner_promotion_logs" do
    let(:fake_phone1) { '13811111111' }
    let(:fake_phone2) { '13811111112' }

    before do
      create(:promotion_log, commissioner: commissioner)
      create(:promotion_log, {c_id: commissioner.id, phone_number: fake_phone1})
      create(:promotion_log, {c_id: commissioner.id, phone_number: fake_phone2})
      create(:promotion_log, {c_id: commissioner.id, phone_number: '13811111113'})
    end

    describe "#get_promotion_logs" do
      it "should return commissioner's promorion logs" do
        expect(subject.get_promotion_logs(commissioner.id, 5, 1).count).to eq 4
        expect(subject.get_promotion_logs(commissioner.id, 5, 2).count).to eq 0
        expect(subject.get_promotion_logs(commissioner.id, 3, 2).count).to eq 1
      end
    end

    describe "#get_promotion_logs_count" do
      it "should return commissioner'logs count" do
        expect(subject.get_promotion_logs_count commissioner.id).to eq 4
      end
    end

    describe "#update_promotion_log" do
      let(:fake_log) { commissioner.promotion_logs.first }

      it "should update commissioner logs's phone_number" do
        subject.update_promotion_log fake_log.id, "13800000000"
        expect(Pandora::Models::PromotionLog.find(fake_log.id).phone_number).to eq "13800000000"
      end
    end

    describe "#add_promotion_log" do

      it "should add new promotion log for commissioner" do
        commissioner.promotion_logs.destroy_all
        subject.add_promotion_log commissioner.id, "13811923432", "iphone"
        expect(Pandora::Models::Commissioner.find(commissioner.id).promotion_logs.count).to eq 1
      end

      it "should add new promotion log for commissioner with correct attributes" do
        commissioner.promotion_logs.destroy_all
        subject.add_promotion_log commissioner.id, "13811923432", "iphone"
        log = Pandora::Models::Commissioner.find(commissioner.id).promotion_logs.first
        expect(log.commissioner).to eq commissioner
        expect(log.phone_number).to eq '13811923432'
        expect(log.mobile_type).to eq 'iphone'
      end

      it "should add raise error if phone_number is not correct" do
        commissioner.promotion_logs.destroy_all
        expect { subject.add_promotion_log commissioner.id, "1381192432", "iphone" }.to raise_error ActiveRecord::RecordInvalid
      end

      it "should add new promotion log successfully even phone_number is nil" do
        commissioner.promotion_logs.destroy_all
        expect { subject.add_promotion_log commissioner.id, nil, "iphone" }.not_to raise_error
      end
    end

    describe "#get_promotion_users" do
      before do
        create(:user, phone_number: fake_phone1)
        create(:user, phone_number: fake_phone2)
      end

      it "should return all commissioner's user" do
        expect(subject.get_promotion_users(commissioner.id).count).to eq 2
      end
    end

    describe "#get_promotion_designers" do
      before do
        user1 = create(:user, phone_number: fake_phone1)
        user2 = create(:user, phone_number: fake_phone2)
        create(:designer, user: user1)
      end

      it "should return all commissioner's designers" do
        expect(subject.get_promotion_designers(commissioner.id).count).to eq 1
      end
    end
  end

  describe "shop promotion log" do
    let(:shop) { create(:shop) }

    describe "#get_shop_promotion_logs" do
      before do
        create(:shop_promotion_log, {c_id: commissioner.id, shop_id: shop.id})
        create(:shop_promotion_log, {c_id: commissioner.id, shop_id: shop.id})
        create(:shop_promotion_log, {c_id: commissioner.id, shop_id: shop.id})
      end

      it "should return commissioner's shop promotion logs" do
        expect(subject.get_shop_promotion_logs(commissioner.id, shop.id, 4, 1).count).to eq 3
        expect(subject.get_shop_promotion_logs(commissioner.id, shop.id, 2, 2).count).to eq 1
        expect(subject.get_shop_promotion_logs(commissioner.id, shop.id, 5, 2).count).to eq 0
      end
    end

    describe "#add_shop_promotion_log" do

      it "should add shop promotion log" do
        subject.add_shop_promotion_log commissioner.id, shop.id, "this is test shop promotion log"
        expect(Pandora::Models::Commissioner.find(commissioner.id).shop_promotion_logs.count).to eq 1
        expect(Pandora::Models::Shop.find(shop.id).promotion_logs.count).to eq 1
      end
    end

  end

  describe "#get_commissioner_QR_code" do
    let(:image) { create(:image) }

    before do
      commissioner.update(code_image_id: image.id)
    end

    it "should return the url of commssioner's QR code" do
      expect(subject.get_commissioner_QR_code commissioner.id).to eq image.url
    end
  end

  describe "#delete_shop" do
    let(:fake_shop_id) { 1000 }

    before do
      create(:shop, id: fake_shop_id)
    end

    it "should update shop'deleted to be true" do
      subject.delete_shop fake_shop_id
      expect(Pandora::Models::Shop.find(fake_shop_id).deleted).to be true
    end
  end

  describe "#register_shop" do
    let(:name) { "new shop" }
    let(:address) { "address" }
    let(:longtitude) { "105.21" }
    let(:latitude) { "34.214" }
    let(:scale) { "middle" }
    let(:category) { "underside" }
    let(:desc) { "very fastion" }

    before do
      Pandora::Models::Shop.destroy_all
    end

    it "should create new shop with correct attributes" do
      new_shop = subject.register_shop name, address, longtitude, latitude, scale, category, desc
      expect(new_shop.name).to eq name
      expect(new_shop.address).to eq address
      expect(new_shop.longtitude).to eq longtitude
      expect(new_shop.latitude).to eq latitude
      expect(new_shop.scale).to eq scale
      expect(new_shop.desc).to eq desc
    end
  end
end