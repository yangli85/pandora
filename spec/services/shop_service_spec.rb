require 'pandora/services/shop_service'
require 'pandora/models/designer'
require 'pandora/models/user'

describe Pandora::Services::ShopService do
  let(:fake_lon) { "108.9420" }
  let(:fake_lat) { "34.2610" }

  describe "#get_vicinal_shops" do
    before do
      create(:shop, latitude: '34.2620', longtitude: '108.9430')
      create(:shop, latitude: '34.2620', longtitude: '108.9440')
      create(:shop, latitude: '34.3620', longtitude: '108.9630')
      create(:shop, latitude: '34.2320', longtitude: '108.9930')
      create(:shop, latitude: '34.2420', longtitude: '108.9430')
    end

    it "should return all vicinal shops in the range" do
      expect(subject.get_vicinal_shops(fake_lon, fake_lat, 5).count).to eq 4
      expect(subject.get_vicinal_shops(fake_lon, fake_lat, 1).count).to eq 2
    end

    it "should in the range for return shops" do
      expect(subject.get_vicinal_shops(fake_lon, fake_lat, 5).all? { |shop| shop.distance <=5 }).to eq true
    end

    it "should ordered shops by distance asc" do
      expect(subject.get_vicinal_shops(fake_lon, fake_lat, 5).each_cons(2).all? { |shop1, shop2| shop1.distance <=shop2.distance }).to eq true
    end
  end

  describe "#get_shop_designers" do
    let(:shop) { create(:shop) }
    let(:user1) { create(:user, phone_number: '13800000001') }
    let(:user2) { create(:user, phone_number: '13800000002') }
    let(:user3) { create(:user, phone_number: '13800000003') }

    before do
      create(:designer, {shop: shop, user: user1})
      create(:designer, {shop: shop, user: user2})
      create(:designer, {shop: shop, user: user3})
    end

    it "should return shop's designers" do
      expect(subject.get_shop_designers(shop.id).count).to eq 3
    end
  end

  describe "#get_shop" do
    let(:shop) { create(:shop) }

    it "should return shop" do
      expect(subject.get_shop shop.id).to eq shop
    end
  end

  describe "#create_shop" do
    let(:fake_name) { 'new shop' }
    let(:fake_address) { 'zhuque street No1 new building' }
    let(:fake_latitude) { '105.124' }
    let(:fake_longtitude) { '205.124' }

    it "should create shop correctly" do
      shop = subject.create_shop fake_name, fake_address, fake_latitude, fake_longtitude
      expect(shop.name).to eq fake_name
      expect(shop.address).to eq fake_address
      expect(shop.latitude).to eq fake_latitude
      expect(shop.longtitude).to eq fake_longtitude
    end
  end

  describe "#search_shops" do
    before do
      create(:shop, name: 'new beauty')
      create(:shop, name: 'new Man')
      create(:shop, name: 'new Style')
    end

    it "should return matched shop" do
      expect(subject.search_shops('new').count).to eq 3
      expect(subject.search_shops('man').count).to eq 1
      expect(subject.search_shops('Sty').count).to eq 1
      expect(subject.search_shops('Styaa').count).to eq 0
    end
  end

  describe "#get_similar_shops" do

    before do
      create(:shop, {name: "new shop 1", address: 'ZhuQue Street Building7', latitude: '100.170', longtitude: '100.10', })
      create(:shop, {name: "new shop 2", address: 'ZhuQue Street Building8', latitude: '100.130', longtitude: '100.170', })
      create(:shop, {name: "new shop 2", address: 'ZhuQue Street Building8', latitude: '100.130', longtitude: '100.10', })
      create(:shop, {name: "new shop 3", address: 'YanNan Street Building9', latitude: '100.100', longtitude: '100.100', })
    end

    it "should return shop's that all attibutes are similar with input" do
      expect(subject.get_similar_shops("new shop", "ZhuQue Street", '100.10', '100.10').count).to eq 1
      expect(subject.get_similar_shops("new shop", "ChangQing Street", '100.10', '100.10').count).to eq 0
      expect(subject.get_similar_shops("new shop", "ZhuQue Street", '100.10', '99.90').count).to eq 0
    end
  end
end