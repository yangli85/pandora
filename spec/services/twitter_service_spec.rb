require 'pandora/services/twitter_service'
require 'pandora/models/image'
require 'pandora/models/user'
require 'pandora/models/twitter'

describe Pandora::Services::TwitterService do
  let(:author) { create(:user, phone_number: '13800000001') }
  let(:designer) { create(:user, phone_number: '13800000002') }
  let(:image1) { create(:image, category: 'twitter') }
  let(:image2) { create(:image, category: 'twitter') }
  let(:image3) { create(:image, category: 'twitter') }
  let(:image4) { create(:image, category: 'twitter') }
  let(:image5) { create(:image, category: 'twitter') }
  let(:twitter1) { create(:twitter, {author: author, designer: designer}) }
  let(:twitter2) { create(:twitter, {author: author, designer: designer}) }

  before do
    create(:twitter_image, {likes: 2, s_image: image1, image: image1, twitter: twitter1, rank: 1})
    create(:twitter_image, {likes: 3, s_image: image2, image: image2, twitter: twitter1, rank: 2})
    create(:twitter_image, {likes: 4, s_image: image3, image: image3, twitter: twitter1, rank: 3})
    create(:twitter_image, {likes: 5, s_image: image4, image: image4, twitter: twitter2, rank: 1})
    create(:twitter_image, {likes: 12, s_image: image5, image: image5, twitter: twitter2, rank: 2})
  end
  describe '#get_ordered_twitter_images' do
    context 'page_size and current_page' do
      it "should return 3 twitter images if page size is 3 and current_page is 1" do
        images = subject.get_ordered_twitter_images 3, 1, 'likes'
        expect(images.count).to eq 3
      end

      it "should return 2 twitter images if page size is 3 and current_page is 2" do
        images = subject.get_ordered_twitter_images 3, 2, 'likes'
        expect(images.count).to eq 2
      end

      it "should return 0 twitter images if page size is 10 and current_page is 2" do
        images = subject.get_ordered_twitter_images 10, 2, 'likes'
        expect(images.count).to eq 0
      end
    end

    context 'order by' do
      it "should return order twitter images by likes desc" do
        images = subject.get_ordered_twitter_images 5, 1, 'likes'
        expect(images.each_cons(2).all? { |image1, image2| image1.likes >= image2.likes }).to eq true
      end
    end

    it "should get whole images info" do
      image = (subject.get_ordered_twitter_images 3, 1, 'likes').first
      expect(image.twitter).to eq twitter2
      expect(image.image).to eq image5
    end
  end
end