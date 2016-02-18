require 'pandora/models/twitter'
require 'pandora/models/twitter_image'
require 'pandora/models/user'
require 'pandora/models/image'
require 'pandora/models/designer'
require 'date'

describe Pandora::Models::Twitter do
  let(:avatar) { create(:image) }
  let(:author) { create(:user, {phone_number: '13811111111', avatar: avatar}) }
  let(:designer) { create(:designer, user: author) }
  let(:twitter) { create(:twitter, {author: author, designer: designer}) }
  let(:image1) { create(:image) }
  let(:image2) { create(:image) }

  describe 'scope' do
    before do
      create(:twitter, {author: author, designer: designer, deleted: false})
      create(:twitter, {author: author, designer: designer, deleted: true})
    end

    context 'default scope' do
      it "should return undeleted twitters" do
        expect(author.twitters.count).to eq 1
      end
    end
  end

  describe 'validate' do
    it "should raise error if content is too long" do
      allow_any_instance_of(String).to receive(:length).and_return(101)
      expect { create(:twitter, {author: author, designer: designer, content: 'content'}) }.to raise_error ActiveRecord::RecordInvalid
    end
  end

  describe 'belongs to' do
    it "should get twitter's author" do
      expect(twitter.author).to eq author
    end

    it "should get twitter's designer" do
      expect(twitter.designer).to eq designer
    end
  end

  describe 'has many' do
    before do
      create(:twitter_image, {twitter: twitter, s_image: image1, image: image1})
      create(:twitter_image, {twitter: twitter, s_image: image2, image: image2})
    end

    it "should get twitter's images" do
      expect(twitter.images.count).to eq 2
    end

    it "should get twitter's s_images" do
      expect(twitter.s_images.count).to eq 2
    end
  end

  describe '#likes' do

    it "should return twitter's sum likes" do
      create(:twitter_image, {likes: 2, twitter: twitter, s_image: image1, image: image1})
      create(:twitter_image, {likes: 3, twitter: twitter, s_image: image2, image: image2})

      expect(twitter.likes).to eq 5
    end

    it "should return 0 if twitter has no image" do
      expect(twitter.likes).to eq 0
    end
  end

  describe '#attribues' do
    let(:fake_result) {
      {
          :id => 1,
          :author =>
              {
                  :id => 1,
                  :name => "user1",
                  :avatar => "images/1.jpg"
              },
          :content => "this is a test twitter",
          :likes => 5,
          :designer =>
              {
                  :id => 1,
                  :user_id => 1,
                  :name => "user1",
                  :avatar => "images/1.jpg"
              },
          :images =>
              [
                  {
                      :s_image => "images/1.jpg",
                      :image => "images/1.jpg",
                      :likes => 2,
                      :rank => 1
                  },
                  {
                      :s_image => "images/1.jpg",
                      :image => "images/1.jpg",
                      :likes => 3,
                      :rank => 1
                  }
              ],
          :created_at =>'1分钟内'
      }
    }

    before do
      allow(Time).to receive(:now).and_return(DateTime.parse('20160218180000'))
      create(:twitter_image, {likes: 2, twitter: twitter, s_image: image1, image: image1})
      create(:twitter_image, {likes: 3, twitter: twitter, s_image: image2, image: image2})
    end

    it "should return needed attributes for the twitter" do
      expect(twitter.attributes).to eq fake_result
    end
  end
end