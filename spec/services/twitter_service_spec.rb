require 'pandora/services/twitter_service'

describe Pandora::Services::TwitterService do
  let(:author) { create(:user, phone_number: '13800000001') }
  let(:user) { create(:user, phone_number: '13800000002') }
  let(:designer) { create(:designer, user: user) }
  let(:s_image) { create(:image, category: 'twitter') }
  let(:image1) { create(:image, {category: 'twitter', s_image: s_image}) }
  let(:image2) { create(:image, {category: 'twitter', s_image: s_image}) }
  let(:image3) { create(:image, {category: 'twitter', s_image: s_image}) }
  let(:image4) { create(:image, {category: 'twitter', s_image: s_image}) }
  let(:image5) { create(:image, {category: 'twitter', s_image: s_image}) }
  let(:twitter1) { create(:twitter, {author: author, designer: designer}) }
  let(:twitter2) { create(:twitter, {author: author, designer: designer}) }

  before do
    create(:twitter_image, {likes: 2, image: image1, twitter: twitter1, rank: 1})
    create(:twitter_image, {likes: 3, image: image2, twitter: twitter1, rank: 2})
    create(:twitter_image, {likes: 4, image: image3, twitter: twitter1, rank: 3})
    create(:twitter_image, {likes: 5, image: image4, twitter: twitter2, rank: 1})
    create(:twitter_image, {likes: 12, image: image5, twitter: twitter2, rank: 2})
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

  describe "#get_twitter_images" do
    it "should return twitter's images" do
      expect(subject.get_twitter_images(twitter1.id).count).to eq 3
    end
  end

  describe "#get_ordered_twitters" do
    it "should return all twitters order by created_at desc" do
      twitters = subject.get_ordered_twitters(2, 1, 'created_at')
      expect(twitters.each_cons(2).all? { |twitter1, twitter2| twitter1.created_at >= twitter2.created_at }).to eq true
    end

    it "should get twitters images from returned twitter" do
      twitter = subject.get_ordered_twitters(2, 1, 'created_at').first
      expect(twitter.images).to eq([image1, image2, image3])
    end
  end

  describe "#search_twitter_by_id" do
    it "should get correct twitter by twitter id" do
      expect(subject.search_twitter_by_id twitter1.id).to eq twitter1
    end

    it "should return nil if no matched twitter" do
      expect(subject.search_twitter_by_id 100).to eq nil
    end
  end

  describe "#create_twitter" do
    let(:fake_author_id) { author.id }
    let(:fake_designer_id) { designer.id }
    let(:fake_content) { 'new twitter' }
    let(:fake_stars) { 3 }
    let(:fake_twitter_images_folder) { "twitter_images" }
    let(:fake_image_paths) { [
        {
            image_path: 'images/1.jpg',
            s_image_path: 'images/s_1.jpg'
        },
        {
            image_path: 'images/2.jpg',
            s_image_path: 'images/s_2.jpg'
        }
    ] }
    before do
      allow(FileUtils).to receive(:mv)
    end

    it "should create twitter" do
      subject.create_twitter(fake_author_id, fake_designer_id, fake_content, fake_image_paths, fake_stars, nil, nil, fake_twitter_images_folder)
      twitter = Pandora::Models::Twitter.last
      expect(twitter.author).to eq author
      expect(twitter.designer).to eq designer
      expect(twitter.content).to eq fake_content
      expect(twitter.stars).to eq fake_stars
    end

    it "should create images for twitter" do
      subject.create_twitter(fake_author_id, fake_designer_id, fake_content, fake_image_paths, fake_stars, nil, nil, fake_twitter_images_folder)
      twitter = Pandora::Models::Twitter.last
      expect(twitter.images.count).to eq(2)
    end

    it "should move the old image to new folder" do
      subject.create_twitter(fake_author_id, fake_designer_id, fake_content, fake_image_paths, fake_stars, nil, nil, fake_twitter_images_folder)
      twitter = Pandora::Models::Twitter.last
      expect(twitter.images.map(&:url)).to eq(["twitter_images/1.jpg", "twitter_images/2.jpg"])
      expect(twitter.images.map(&:s_image).map(&:url)).to eq(["twitter_images/s_1.jpg", "twitter_images/s_2.jpg"])
    end
  end
end