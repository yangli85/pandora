require 'pandora/models/ad_image'
require 'pandora/models/image'

describe Pandora::Models::AdImage do
  let(:image) { create(:image) }
  let(:ad_image1) { create(:ad_image, image: image) }
  let(:ad_image2) { create(:ad_image, image_id: image.id) }

  it "should get related image" do
    expect(ad_image1.image).to eq image
  end

  it "should get related image if create ad_image with image_id" do
    expect(ad_image2.image).to eq image
  end
end