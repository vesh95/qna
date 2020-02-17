FactoryBot.define do
  factory :vote do
    association :user
    rate { 1 }
  end
end
