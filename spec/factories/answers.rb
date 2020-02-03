FactoryBot.define do

  factory :answer do
    body { "MyText" }
    association :question
    association :user

    trait :questionless do
      question { nil }
    end

    trait :invalid do
      body { nil }
    end

    trait :list_of_answers do
      sequence :body do |n|
        "Answer#{n}"
      end
    end
  end
end
