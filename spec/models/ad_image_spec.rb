require 'pandora/models/ad_image'
require 'pandora/models/image'

describe Pandora::Models::AdImage do
  let(:image) {create(:image)}

  it "should get related image" do
    ad_image = create(:ad_image,image: image)
    expect(ad_image.image).to eq image
  end
end