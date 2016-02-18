require 'pandora/models/vita'
require 'pandora/models/designer'
require 'pandora/models/user'
require 'pandora/models/image'
require 'pandora/models/vita_image'
require 'date'

describe Pandora::Models::Vita do
  let(:user) { create(:user) }
  let(:designer) { create(:designer, user: user) }
  let(:vita) { create(:vita, designer: designer) }
  before do
    image1 = create(:image)
    image2 = create(:image)
    create(:vita_image, {image: image1, s_image: image1, vita: vita})
    create(:vita_image, {image: image2, s_image: image1, vita: vita})
  end

  describe 'has many' do
    context "images" do
      it "should return all vita images" do
        expect(vita.images.count).to eq(2)
      end

      it "should return all vita small images" do
        expect(vita.s_images.count).to eq(2)
      end
    end
  end

  describe '#attributes' do
    let(:fake_result) {
      {
          :id => 1,
          :desc => "this is a test vita",
          :images =>
              [
                  {
                      :s_image => "images/1.jpg",
                      :image => "images/1.jpg"
                  },
                  {
                      :s_image => "images/1.jpg",
                      :image => "images/1.jpg"
                  }
              ],
          :created_at => "1分钟内"}
    }
    it "should return wanted attributes of vita" do
      allow_any_instance_of(Pandora::Models::Vita).to receive(:relative_time).and_return("1分钟内")
      expect(vita.attributes).to eq fake_result
    end
  end
end