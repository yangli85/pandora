require 'pandora/models/shop'

describe Pandora::Models::Shop do
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
    expect(shop.designers.count).to eq 3
  end
end