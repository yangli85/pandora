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

      it "should raise error if type is wrong" do
        expect { create(:image, type: 'wrong') }.to raise_error ActiveRecord::RecordInvalid
      end

      it "should raise error if type is wrong" do
        expect { create(:image, type: nil) }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context 'success' do
      it "shoud create image successfully if type is right" do
        expect{create(:image, type: 'unknow')}.not_to raise_error
      end

      it "shoud create image successfully if url is right" do
        expect{create(:image, url: 'images/1.jpg')}.not_to raise_error
      end
    end
  end
end