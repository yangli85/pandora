FactoryGirl.define do
  sequence(:image_name) { |n| n }

  factory :image, :class => 'Pandora::Models::Image' do
    type 'avatar'
    url "images/#{FactoryGirl.generate(:image_name)}.jpg"
  end
end