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

    trait :with_files do
      after :create do |answer|
        answer.files.attach(
          [{
              io: File.open("#{Rails.root}/Rakefile"),
              filename: 'Rakefile'
            },{
              io: File.open("#{Rails.root}/Gemfile"),
              filename: 'Gemfile'
            }]
        )
      end
    end
  end
end
