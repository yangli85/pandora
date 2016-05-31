require 'pandora/services/designer_service'
require 'pandora/models/shop'
require 'pandora/models/twitter'

describe Pandora::Services::DesignerService do
  let(:shop) { create(:shop) }
  let(:user1) { create(:user, {phone_number: '13800000001', name: 'tommy zhang'}) }
  let(:user2) { create(:user, {phone_number: '13800000002', name: 'tommy li'}) }
  let(:user3) { create(:user, {phone_number: '13800000003', name: 'tommy han'}) }

  before do
    allow(subject).to receive(:get_image_size).and_return({width: 1000, height: 2000})
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

  describe "#get_designer" do
    it "should return designer info if designer exist" do
      expect(subject.get_designer(2).user.id).to eq 2
    end

    it "should return nil info if designer not exist" do
      expect(subject.get_designer('no exist')).to eq nil
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
        expect(subject.get_designer_twitters(designer.id, 2, 1).count).to eq 2
        expect(subject.get_designer_twitters(designer.id, 5, 1).count).to eq 3
        expect(subject.get_designer_twitters(designer.id, 5, 2).count).to eq 0
      end

      it "should ordered twitters by create_at'" do
        expect(subject.get_designer_twitters(designer.id, 5, 1).each_cons(2).all? { |t1, t2| t1.created_at >= t2.created_at }).to eq true
      end
    end

    context 'designer not exist' do
      it "should return nil if designer not exist" do
        expect(subject.get_designer_twitters(10, 5, 1)).to eq nil
      end
    end
  end

  describe "#delete_twitter" do
    let(:user) { create(:user, phone_number: '13800000004') }
    let(:author) { create(:user, phone_number: '13800000005') }
    let(:designer) { create(:designer, user: user) }

    before do
      create(:twitter, {author: author, designer: designer})
    end

    it "should update twitter.deleted to be true" do
      subject.delete_twitter designer.id, 1
      expect(designer.twitters.active.count).to eq 0
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
      s_image1 = create(:image, original_image: image1)
      s_image2 = create(:image, original_image: image2)
      s_image3 = create(:image, original_image: image3)
      s_image4 = create(:image, original_image: image4)
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
          expect(subject.get_designer_vitae(designer.id, 5, 1).count).to eq 4
          expect(subject.get_designer_vitae(designer.id, 2, 1).count).to eq 2
          expect(subject.get_designer_vitae(designer.id, 5, 2).count).to eq 0
        end

        it "should ordered vita by created_at'" do
          expect(subject.get_designer_vitae(designer.id, 5, 1).each_cons(2).all? { |v1, v2| v1.created_at >= v2.created_at }).to eq true
        end
      end

      context 'designer not exist' do
        it "should return nil if designer not exist" do
          expect(subject.get_designer_vitae(10, 5, 1)).to eq nil
        end
      end
    end

    describe '#delete_designer_vitae' do
      it "should can delete muiltiple vitae" do
        subject.delete_designer_vitae designer.vitae.map(&:id)
        expect(designer.vitae.count).to eq 0
      end

      it "should can delete single vitae" do
        subject.delete_designer_vitae designer.vitae.first.id
        expect(designer.vitae.count).to eq 3
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
      let(:fake_image_paths) {
        [
            {
                image_path: 'images/1.jpg',
                s_image_path: 'images/1.jpg'
            },
            {
                image_path: 'images/2.jpg',
                s_image_path: 'images/2.jpg'
            }
        ]
      }
      let(:fake_vita_image_folder) { 'temp_images' }

      before do
        allow(FileUtils).to receive(:mv)
        designer.vitae.destroy_all
      end

      it "should create vita for designer" do
        subject.create_vita designer.id, fake_image_paths, fake_desc, fake_vita_image_folder
        expect(designer.vitae.count).to eq 1
      end

      it "should create vita images for vita" do
        subject.create_vita designer.id, fake_image_paths, fake_desc, fake_vita_image_folder
        expect(Pandora::Models::VitaImage.count).to eq 2
      end

      it "should create images for vita" do
        subject.create_vita designer.id, fake_image_paths, fake_desc, fake_vita_image_folder
        expect(Pandora::Models::Image.count).to eq 4
      end
    end
  end

  describe '#search_designers' do
    it "should return correct search result" do
      expect(subject.search_designers(5, 1, 'tommy').count).to eq 3
      expect(subject.search_designers(5, 1, 'zhang').count).to eq 1
      expect(subject.search_designers(5, 1, 'li').count).to eq 1
      expect(subject.search_designers(5, 1, '138').count).to eq 3
      expect(subject.search_designers(5, 1, '13800000001').count).to eq 1
      expect(subject.search_designers(5, 2, '13800000001').count).to eq 0
    end

    it "should order by totally stars" do
      expect(subject.search_designers(5, 1, 'tommy').each_cons(2).all? { |designer1, designer2| designer1.totally_stars >= designer2.totally_stars }).to eq true
    end
  end

  describe '#get_designer_rank' do
    before do
      new_user = create(:user, {phone_number: '13800000004', name: 'tommy liu'})
      create(:designer, {shop: shop, user: new_user, totally_stars: 2, is_vip: true, created_at: Time.parse("2016-03-12 04:30:39 UTC")})
    end

    it "should return correct rank" do
      expect(subject.get_designer_rank 1, 'totally_stars').to eq 4
      expect(subject.get_designer_rank 2, 'totally_stars').to eq 3
      expect(subject.get_designer_rank 4, 'totally_stars').to eq 2
    end
  end

  describe '#get_designer_shop' do
    it "should return designer's shop" do
      designer = Pandora::Models::Designer.first
      expect(subject.get_designer_shop designer.id).to eq shop
    end
  end

  describe '#get_customers' do
    let(:user1) { create(:user, {phone_number: '13800000001', name: 'Abc'}) }
    let(:user2) { create(:user, {phone_number: '13800000002', name: 'Bcd'}) }
    let(:user3) { create(:user, {phone_number: '13800000003', name: 'Cde'}) }
    let(:user) { create(:user, phone_number: '13811978823') }
    let(:designer) { create(:designer, user: user) }

    before do
      create(:favorite_designer, {user: user2, favorited_designer: designer})
      create(:favorite_designer, {user: user1, favorited_designer: designer})
      create(:favorite_designer, {user: user3, favorited_designer: designer})
    end

    it "should return designer's users in page" do
      expect(subject.get_customers(designer.id, 3, 1).count).to eq 3
      expect(subject.get_customers(designer.id, 2, 1).count).to eq 2
      expect(subject.get_customers(designer.id, 2, 2).count).to eq 1
    end

    it "should return designer's users in order" do
      expect(subject.get_customers(designer.id, 3, 1)).to eq [user1, user2, user3]
      expect(subject.get_customers(designer.id, 2, 1)).to eq [user1, user2]
      expect(subject.get_customers(designer.id, 2, 1)).to eq [user1, user2]
    end
  end

  describe '#search_customers' do
    let(:user1) { create(:user, {phone_number: '13800000001', name: 'Abc'}) }
    let(:user2) { create(:user, {phone_number: '13800000002', name: 'Bcd'}) }
    let(:user3) { create(:user, {phone_number: '13800000003', name: 'Cde'}) }
    let(:user) { create(:user, phone_number: '13811978823') }
    let(:designer) { create(:designer, user: user) }

    before do
      create(:favorite_designer, {user: user2, favorited_designer: designer})
      create(:favorite_designer, {user: user1, favorited_designer: designer})
      create(:favorite_designer, {user: user3, favorited_designer: designer})
    end

    it "should return searched designer's users in page" do
      expect(subject.search_customers(designer.id, '138', 3, 1).count).to eq 3
      expect(subject.search_customers(designer.id, '13800000001', 3, 1).count).to eq 1
      expect(subject.search_customers(designer.id, 'Ab', 3, 1).count).to eq 1
      expect(subject.search_customers(designer.id, 'aaaa', 3, 1).count).to eq 0
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

  describe '#update_designer' do
    let(:user) { create(:user) }
    let(:designer) { create(:designer, {shop: shop, user: user}) }
    it "should update designer totally_stars" do
      subject.update_designer designer.id, 'totally_stars', 10
      expect(Pandora::Models::Designer.find(designer.id).totally_stars).to eq 10
    end
  end

  describe "#get_new_designer" do
    let(:user) { create(:user) }

    it "should return new register designer" do
      designer = create(:designer, {shop: shop, user: user, is_vip: true})
      expect(subject.get_new_designer).to eq designer
    end
  end

  describe "#get_top1_designer" do
    let(:user) { create(:user) }

    it "should return new register designer" do
      designer = subject.get_top1_designer "totally_stars"
      new_designer = create(:designer, {shop: shop, user: user, totally_stars: designer.totally_stars+1, is_vip: true})
      expect(subject.get_top1_designer "totally_stars").to eq new_designer
    end
  end
end