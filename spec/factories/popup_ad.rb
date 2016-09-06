FactoryGirl.define do
  factory :popup_ad, :class => 'Pandora::Models::PopupAd' do
    image_url "image_url"
    link "link"
    category "INTERNAL_LINK"
  end
end