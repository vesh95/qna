FactoryBot.define do

  factory :answer do
    sequence :body do |n|
      "Answer#{n}"
    end

    association :question
    association :user

    trait :questionless do
      question { nil }
    end

    trait :invalid do
      body { nil }
    end
  end
end
