include ActionDispatch::TestProcess

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
    end

    trait :with_files do
      after :create do |answer|
        answer.files.attach(
          [{
              io: File.open("#{Rails.root}/README.md"),
              filename: 'README.md'
            },{
              io: File.open("#{Rails.root}/config.ru"),
              filename: 'config.ru'
            }]
        )
      end
    end

  end
end
