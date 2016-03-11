require "pandora/models/favorite_designer"
require "pandora/models/user"
require "pandora/models/designer"

describe Pandora::Models::FavoriteDesigner do
  let(:user) { create(:user) }
  let(:user_designer) { create(:user, phone_number: "13812345678") }
  let(:designer) { create(:designer, {user: user_designer, likes: 0}) }

  it "should update designer's likes" do
    create(:favorite_designer, {favorited_designer: designer, user: user})
    expect(Pandora::Models::Designer.find(designer.id).likes).to eq 1
    Pandora::Models::FavoriteDesigner.destroy_all
    expect(Pandora::Models::Designer.find(designer.id).likes).to eq 0
  end
end