require 'pandora/models/designer'
require 'pandora/models/user'
require 'pandora/models/shop'
require 'pandora/models/twitter'
require 'pandora/models/vita'

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

      it "should return nil if no shop info" do
        expect(designer.shop).to eq nil
      end
    end
  end

  describe "has many" do
    context 'twitters' do
      before do
        create(:twitter, {author: user, designer: designer})
        create(:twitter, {author: user, designer: designer})
        create(:twitter, {author: user, designer: designer})
        create(:twitter, {author: user, designer: designer})
      end

      it "should return all twitters for designer" do
        expect(designer.twitters.count).to eq 4
      end
    end

    context 'vitae' do
      before do
        create(:vita, designer: designer)
        create(:vita, designer: designer)
        create(:vita, designer: designer)
      end

      it "should return all viate for designer" do
        expect(designer.vitae.count).to eq 3
      end
    end
  end

  describe "validate" do
    it "should map to a exist user when create a designer" do
      expect { create(:designer) }.to raise_error ActiveRecord::RecordInvalid
    end

    it "should return error if user id is not unique in designer" do
      create(:designer, user: user)
      expect { create(:designer, user: user) }.to raise_error ActiveRecord::RecordInvalid
    end
  end
end