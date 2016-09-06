require 'pandora/services/ad_service'
require 'pandora/models/image'

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

  describe "#get_latest_popup_ad" do
    before do
      create(:popup_ad, {id: 1, image_url: 'url1', link: 'link1', category: 'INTERNAL_LINK'})
      create(:popup_ad, {id: 2, image_url: 'url2', link: 'link2', category: 'INTERNAL_LINK'})
      create(:popup_ad, {id: 3, image_url: 'url3', link: 'link3', category: 'INTERNAL_LINK'})
      create(:popup_ad, {id: 4, image_url: 'url4', link: 'link4', category: 'INTERNAL_LINK'})
    end
    it "should return latest ad info" do
      latest_ad = subject.get_latest_popup_ad
      expect(latest_ad.id).to eq 4
      expect(latest_ad.link).to eq 'link4'
    end
  end

end