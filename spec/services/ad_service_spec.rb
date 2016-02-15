require 'pandora/services/ad_service'

describe Pandora::Services::AdService do
  let(:image1) { create(:image, category: 'ad') }
  let(:image2) { create(:image, category: 'ad') }

  before do
    create(:ad_image, {image: image1, category: 'index'})
    create(:ad_image, {image: image2, category: 'banner'})
  end

  describe "#get_ad_images" do
    it "should return all index ad images" do
      images = subject.get_ad_images 'index'
      expect(images.count).to eq 1
      expect(images.first.image).to eq image1
    end
  end

end