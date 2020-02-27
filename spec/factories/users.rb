FactoryBot.define do
  sequence :email do |n|
    "user#{n}@mail"
  end

  factory :user do
    email
    password { '12345678' }
    confirmed_at { Time.now }
  end
end
