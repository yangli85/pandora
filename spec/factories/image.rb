FactoryGirl.define do
  sequence(:image_name) { |n| n }

  factory :image, :class => 'Pandora::Models::Image' do
    category 'avatar'
    width 1000
    height 1500
    url "images/#{FactoryGirl.generate(:image_name)}.jpg"
  end
end