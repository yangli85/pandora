require 'spec_helper'
require 'pandora/models/image'

describe Pandora::Models::Image do
  describe 'validate' do
    context 'error' do
      it 'should raise error if url is nil' do
        expect { create(:image, url: nil) }.to raise_error ActiveRecord::RecordInvalid
      end

      it 'should raise error if url is empty' do
        expect { create(:image, url: '') }.to raise_error ActiveRecord::RecordInvalid
      end

      it 'should raise error if url is blank' do
        expect { create(:image, url: '   ') }.to raise_error ActiveRecord::RecordInvalid
      end

      it "should raise error if category is wrong" do
        expect { create(:image, category: 'wrong') }.to raise_error ActiveRecord::RecordInvalid
      end

      it "should raise error if category is wrong" do
        expect { create(:image, category: nil) }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context 'success' do
      it "shoud create image successfully if category is right" do
        expect { create(:image, category: 'unknow') }.not_to raise_error
      end

      it "shoud create image successfully if url is right" do
        expect { create(:image, url: 'images/1.jpg') }.not_to raise_error
      end
    end
  end

  describe "has s_image" do
    let(:image) { create(:image) }
    let(:s_image) { create(:image, original_image_id: image.id) }

    it "should return image's s_images" do
      expect(image.s_images).to eq [s_image]
    end

    it "should delete small image if delete image" do
      s_image_id = s_image.id
      image.destroy
      expect { Pandora::Models::Image.find(s_image_id) }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end