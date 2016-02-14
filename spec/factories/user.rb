# encoding: UTF-8
FactoryGirl.define do
  sequence(:identity) { |n| n }
  phone_number = rand.to_s[2..12]

  factory :user, :class => 'Pandora::Models::User' do
    name "用户#{FactoryGirl.generate(:identity)}"
    gender 'unknow'
    phone_number phone_number
    avatar nil
    vitality 100
  end
end