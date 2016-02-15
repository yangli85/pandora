FactoryGirl.define do
  factory :designer, :class => 'Pandora::Models::Designer' do
    is_vip false
    expired_at '2015-12-12'
    stars 3
    likes 3
  end
end