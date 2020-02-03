FactoryBot.define do
  factory :question do

    title { "MyString" }
    body { "MyText" }
    association :user

    trait :invalid do
      title { nil }
    end

    trait :list_of_questions do
      sequence :title do |n|
        "Question#{n}"
      end

      sequence :body do |n|
        "QuestionBody#{n}"
      end

      association :user
    end
  end
end
