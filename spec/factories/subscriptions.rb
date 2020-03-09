FactoryBot.define do
  factory :subscription do
    association :user
    association :question
  end
end
