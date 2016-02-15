require 'pandora/services/sms_service'

describe Pandora::Services::SMSService do
  let(:fake_phone_number) { '13811739234' }
  let(:fake_code) { '1234' }

  describe '#update_code' do

    context "create" do
      it "should create a new record to store sms code" do
        subject.update_code fake_phone_number, fake_code
        sms_code = Pandora::Models::SMSCode.find_by_phone_number(fake_phone_number)
        expect(sms_code.code).to eq fake_code
      end
    end

    context "update" do
      before do
        create(:sms_code, {code: '1111', phone_number: fake_phone_number})
      end

      it "should update code" do
        subject.update_code fake_phone_number, fake_code
        sms_code = Pandora::Models::SMSCode.find_by_phone_number(fake_phone_number)
        expect(sms_code.code).to eq fake_code
      end
    end
  end

  describe '#get_latest_code' do

    it "should return nil if no record" do
      expect(subject.get_latest_code fake_phone_number).to eq nil
    end

    it "should return latest sms code" do
      sms_code = create(:sms_code, {code: fake_code, phone_number: fake_phone_number})
      expect(subject.get_latest_code fake_phone_number).to eq sms_code
    end
  end
end