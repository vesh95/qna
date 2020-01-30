FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question { :question }

    trait :questionless do
      question { nil }
    end

    trait :invalid do
      body { "MyAnswer" }
    end
  end
end
