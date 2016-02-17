require 'pandora/services/designer_service'
require 'pandora/models/shop'
require 'pandora/models/twitter'

describe Pandora::Services::DesignerService do
  let(:shop) { create(:shop) }
  let(:user1) { create(:user, {phone_number: '13800000001', name: 'tommy zhang'}) }
  let(:user2) { create(:user, {phone_number: '13800000002', name: 'tommy li'}) }
  let(:user3) { create(:user, {phone_number: '13800000003', name: 'tommy han'}) }

  before do
    create(:designer, {shop: shop, user: user2, totally_stars: 1, is_vip: true})
    create(:designer, {shop: shop, user: user1, totally_stars: 2, is_vip: true})
    create(:designer, {shop: shop, user: user3, totally_stars: 3, is_vip: false})
  end

  describe "#get_ordered_designers" do
    it "should return only current page' designers" do
      expect(subject.get_ordered_designers(1, 2, 'totally_stars').count).to eq 1
      expect(subject.get_ordered_designers(2, 1, 'totally_stars').count).to eq 2
      expect(subject.get_ordered_designers(5, 1, 'totally_stars').count).to eq 2
    end

    it "should order designers by totally_stars" do
      expect(subject.get_ordered_designers(5, 1, 'totally_stars').each_cons(2).all? { |designer1, designer2| designer1.totally_stars >= designer2.totally_stars }).to eq true
    end
  end

  describe "#get_designer_by_user_id" do
    it "should return designer info if designer exist" do
      expect(subject.get_designer_by_user_id(user1.id).id).to eq (2)
    end

    it "should return nil info if designer not exist" do
      expect(subject.get_designer_by_user_id('no exist')).to eq nil
    end
  end

  describe "#get_designer_twitters" do
    let(:user) { create(:user, phone_number: '13800000004') }
    let(:author) { create(:user, phone_number: '13800000005') }
    let(:designer) { create(:designer, user: user) }
    before do
      create(:twitter, {author: author, designer: designer})
      create(:twitter, {author: author, designer: designer})
      create(:twitter, {author: author, designer: designer})
      create(:twitter, {author: author, designer: designer, deleted: true})
    end

    context 'designer exist' do
      it "should return only current page's twitters(undeleted)" do
        expect(subject.get_designer_twitters(designer.id, 2, 1, 'created_at').count).to eq 2
        expect(subject.get_designer_twitters(designer.id, 5, 1, 'created_at').count).to eq 3
        expect(subject.get_designer_twitters(designer.id, 5, 2, 'created_at').count).to eq 0
      end

      it "should ordered twitters by create_at'" do
        expect(subject.get_designer_twitters(designer.id, 5, 1, 'created_at').each_cons(2).all? { |t1, t2| t1.created_at >= t2.created_at }).to eq true
      end
    end

    context 'designer not exist' do
      it "should return nil if designer not exist" do
        expect(subject.get_designer_twitters(10, 5, 1, 'created_at')).to eq nil
      end
    end
  end

  describe 'vitae' do
    let(:user) { create(:user, phone_number: '13800000004') }
    let(:designer) { create(:designer, user: user) }

    before do
      image1 = create(:image)
      image2 = create(:image)
      image3 = create(:image)
      image4 = create(:image)
      vita1 = create(:vita, designer: designer)
      vita2 = create(:vita, designer: designer)
      vita3 = create(:vita, designer: designer)
      vita4 = create(:vita, designer: designer)
      create(:vita_image, {image: image1, vita: vita1})
      create(:vita_image, {image: image2, vita: vita2})
      create(:vita_image, {image: image3, vita: vita3})
      create(:vita_image, {image: image4, vita: vita4})
    end

    describe '#get_designer_vitae' do
      context 'designer exist' do
        it "should return designer's vitae'" do
          expect(subject.get_designer_vitae(designer.id).count).to eq 4
        end

        it "should ordered twitters by create_at'" do
          expect(subject.get_designer_twitters(designer.id, 5, 1, 'created_at').each_cons(2).all? { |v1, v2| v1.created_at >= v2.created_at }).to eq true
        end
      end

      context 'designer not exist' do
        it "should return nil if designer not exist" do
          expect(subject.get_designer_vitae(10)).to eq nil
        end
      end
    end

    describe '#delete_designer_vitae' do
      it "should can delete muiltiple vitae" do
        subject.delete_designer_vitae designer.vitae.map(&:id)
        expect(Pandora::Models::Vita.count).to eq 0
      end

      it "should can delete single vitae" do
        subject.delete_designer_vitae designer.vitae.first.id
        expect(Pandora::Models::Vita.count).to eq 3
      end

      it "should delete vita's vita_images" do
        subject.delete_designer_vitae designer.vitae.map(&:id)
        expect(Pandora::Models::VitaImage.count).to eq 0
      end

      it "should delete vita's images" do
        subject.delete_designer_vitae designer.vitae.map(&:id)
        expect(Pandora::Models::Image.count).to eq 0
      end
    end

    describe '#create_vita' do
      let(:fake_desc) { 'this is a new vita' }
      let(:fake_image_paths) { ['images/1.jpg', 'images/2.jpg'] }

      before do
        designer.vitae.destroy_all
      end

      it "should create vita for designer" do
        subject.create_vita designer.id,fake_image_paths,fake_desc
        expect(designer.vitae.count).to eq 1
      end

      it "should create vita images for vita" do
        subject.create_vita designer.id,fake_image_paths,fake_desc
        expect(Pandora::Models::VitaImage.count).to eq 2
      end

      it "should create images for vita" do
        subject.create_vita designer.id,fake_image_paths,fake_desc
        expect(Pandora::Models::Image.count).to eq 2
      end
    end
  end

  describe '#search_designers' do
    it "should return correct search result" do
      expect(subject.search_designers(5, 1, 'tommy').count).to eq 2
      expect(subject.search_designers(5, 1, 'zhang').count).to eq 1
      expect(subject.search_designers(5, 1, 'li').count).to eq 1
      expect(subject.search_designers(5, 1, '138').count).to eq 2
      expect(subject.search_designers(5, 1, '13800000001').count).to eq 1
    end

    it "should order by totally stars" do
      expect(subject.search_designers(5, 1, 'tommy').each_cons(2).all? { |designer1, designer2| designer1.totally_stars >= designer2.totally_stars }).to eq true
    end
  end

  describe '#get_designer_rank' do
    it "should return correct rank" do
      expect(subject.get_designer_rank 1, 'totally_stars').to eq 3
      expect(subject.get_designer_rank 3, 'totally_stars').to eq 1
    end
  end

  describe '#get_designer_shop' do
    it "should return designer's shop" do
      designer = Pandora::Models::Designer.first
      expect(subject.get_designer_shop designer.id).to eq shop
    end
  end

  describe '#get_customers' do
    let(:user) { create(:user, phone_number: '13811978823') }
    let(:designer) { create(:designer, user: user) }
    let(:user4) { create(:user, {phone_number: '13800000004'}) }
    let(:user5) { create(:user, {phone_number: '13800000005'}) }
    let(:user6) { create(:user, {phone_number: '13800000006'}) }
    let(:user7) { create(:user, {phone_number: '13800000007'}) }
    let(:user8) { create(:user, {phone_number: '13800000008'}) }
    let(:user9) { create(:user, {phone_number: '13800000009'}) }
    let(:user10) { create(:user, {phone_number: '13800000010'}) }
    let(:user11) { create(:user, {phone_number: '13800000011'}) }

    before do
      create(:twitter, {author: user1, designer: designer, created_at: '2016-02-17 09:29:00'})
      create(:twitter, {author: user2, designer: designer, created_at: '2016-02-17 10:29:00'})
      create(:twitter, {author: user3, designer: designer, created_at: '2016-02-17 11:29:00'})
      create(:twitter, {author: user4, designer: designer, created_at: '2016-02-17 12:29:00'})
      create(:twitter, {author: user5, designer: designer, created_at: '2016-02-17 13:29:00'})
      create(:twitter, {author: user6, designer: designer, created_at: '2016-02-17 14:29:00'})
      create(:twitter, {author: user7, designer: designer, created_at: '2016-02-17 15:29:00'})
      create(:twitter, {author: user8, designer: designer, created_at: '2016-02-17 16:29:00'})
      create(:twitter, {author: user9, designer: designer, created_at: '2016-02-17 17:29:00'})
      create(:twitter, {author: user10, designer: designer, created_at: '2016-02-17 18:29:00'})
      create(:twitter, {author: user11, designer: designer, created_at: '2016-02-17 19:29:00'})
      create(:twitter, {author: user11, designer: designer, created_at: '2016-02-17 20:29:00'})
      create(:twitter, {author: user11, designer: designer, created_at: '2016-02-17 21:29:00'})
    end

    it "should return first 10 users" do
      expect(subject.get_customers(designer.id).count).to eq 10
    end

    it "should latest uniq 10 users" do
      expect(subject.get_customers(designer.id)).to eq [user11, user10, user9, user8, user7, user6, user5, user4, user3, user2]
    end
  end

  describe '#update_shop' do
    let(:new_shop) { create(:shop) }
    let(:user) { create(:user) }
    let(:designer) { create(:designer, {shop: shop, user: user}) }

    it 'should update designer shop' do
      subject.update_shop designer.id, new_shop.id
      expect(Pandora::Models::Designer.find(designer.id).shop).to eq new_shop
    end
  end
end