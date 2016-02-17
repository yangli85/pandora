require 'pandora/models/vita'
require 'pandora/models/designer'
require 'pandora/models/user'
require 'pandora/models/image'
require 'pandora/models/vita_image'

describe Pandora::Models::Vita do
  describe 'has many' do
    let(:user) { create(:user) }
    let(:designer) { create(:designer, user: user) }
    let(:vita) { create(:vita, designer: designer) }

    context "images" do
      before do
        image1 = create(:image)
        image2 = create(:image)
        create(:vita_image, {image: image1, vita: vita})
        create(:vita_image, {image: image2, vita: vita})
      end

      it "should return all vita images" do
        expect(vita.images.count).to eq(2)
      end
    end
  end
end