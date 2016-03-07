require 'pandora/common/time_helper'
require 'date'

class DummyClass
  include Pandora::Common::TimeHelper
end

describe DummyClass do
  let(:subject) { DummyClass.new }

  before do
    allow(Time).to receive(:now).and_return( Time.parse(DateTime.parse('20160218180000').to_s))
  end

  context 'in one min' do
    it "should return 1 分钟内" do
      expect(subject.relative_time Time.parse(DateTime.parse('20160218175959').to_s)).to eq '1分钟内'
      expect(subject.relative_time Time.parse(DateTime.parse('20160218175930').to_s)).to eq '1分钟内'
      expect(subject.relative_time Time.parse(DateTime.parse('20160218175901').to_s)).to eq '1分钟内'
    end
  end

  context 'in one hour' do
    it "should return n 分钟前" do
      expect(subject.relative_time Time.parse(DateTime.parse('20160218175859').to_s)).to eq '1分钟前'
      expect(subject.relative_time Time.parse(DateTime.parse('20160218174030').to_s)).to eq '19分钟前'
      expect(subject.relative_time Time.parse(DateTime.parse('20160218170001').to_s)).to eq '59分钟前'
    end
  end

  context 'in one day' do
    it "should return n 天前" do
      expect(subject.relative_time Time.parse(DateTime.parse('20160218170000').to_s)).to eq '1小时前'
      expect(subject.relative_time Time.parse(DateTime.parse('20160218134030').to_s)).to eq '4小时前'
      expect(subject.relative_time Time.parse(DateTime.parse('20160217180001').to_s)).to eq '23小时前'
    end
  end

  context 'in one month' do
    it "should return n 天前" do
      expect(subject.relative_time Time.parse(DateTime.parse('20160217170000').to_s)).to eq '1天前'
      expect(subject.relative_time Time.parse(DateTime.parse('20160201170000').to_s)).to eq '17天前'
      expect(subject.relative_time Time.parse(DateTime.parse('20160119180000').to_s)).to eq '30天前'
    end
  end

  context 'others' do
    it "should return n 天前" do
      expect(subject.relative_time Time.parse(DateTime.parse('20160117170000').to_s)).to eq '2016/01/17'
      expect(subject.relative_time Time.parse(DateTime.parse('20150117170000').to_s)).to eq '2015/01/17'
    end
  end
end