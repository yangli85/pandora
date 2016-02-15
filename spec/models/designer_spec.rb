require 'pandora/models/designer'
require 'pandora/models/user'
require 'pandora/models/shop'

describe Pandora::Models::Designer do
  let(:user) { create(:user) }
  let(:designer) { create(:designer, user: user) }

  describe "belongs to" do
    context 'user' do
      it "should get user info by designer" do
        expect(designer.user).to eq user
      end
    end

    context 'shop' do
      it "should get shop info by designer" do
        shop = create(:shop)
        designer.update(shop: shop)
        expect(designer.shop).to eq shop
      end
    end
  end

  describe "validate" do
    it "should map to a exist user when create a designer" do
      expect{create(:designer)}.to raise_error  ActiveRecord::RecordInvalid
    end
  end
end