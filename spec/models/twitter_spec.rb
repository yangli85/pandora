require 'pandora/models/twitter'
require 'pandora/models/twitter_image'
require 'pandora/models/user'
require 'pandora/models/image'
require 'pandora/models/designer'

describe Pandora::Models::Twitter do
  let(:author) { create(:user, phone_number: '13811111111') }
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
end