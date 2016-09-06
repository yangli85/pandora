FactoryGirl.define do
  factory :shared_twitter, :class => 'Pandora::Models::SharedTwitter' do
    user_id 1
    twitter_id 1
    channel 'WX'
  end
end