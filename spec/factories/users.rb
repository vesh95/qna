FactoryBot.define do
  sequence :email do |n|
    "user#{n}@mail"
  end

  factory :user do
    email
    password { '12345678' }
    password_conformation { '12345678' }
  end
end
