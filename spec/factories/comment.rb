FactoryBot.define do
  factory :comment do
    text { "MyText" }
    commentable { nil }
    association :user
  end
end
