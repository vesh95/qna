FactoryBot.define do
  sequence :title do |n|
    "Qusetion#{n}"
  end

  sequence :body do |n|
    "QusetionBody#{n}"
  end

  factory :question do
    title { "MyString" }
    body { "MyText" }
    association :user

    trait :invalid do
      title { nil }
    end

    trait :list_of_questions do
      title
      body
      association :user
    end
  end
end
