FactoryBot.define do
  factory :answer do
    body { "MyText" }
    association :question, factory: :question

    trait :questionless do
      question { nil }
    end

    trait :invalid do
<<<<<<< HEAD
      body { "MyAnswer" }
=======
      body { nil }
>>>>>>> Created Answers resources
    end
  end
end
