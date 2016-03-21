FactoryGirl.define do
  factory :login_user, :class => 'Pandora::Models::LoginUser' do
    access_token "123456"
  end
end