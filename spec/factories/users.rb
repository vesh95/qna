FactoryBot.define do
  sequence :email do |n|
    "user#{n}@mail"
  end

  factory :user do
    email
    password { '12345678' }

    # REVIEW: Для создания пользователя данный атрибут не нужен
    # password_conformation { '12345678' }
  end
end
