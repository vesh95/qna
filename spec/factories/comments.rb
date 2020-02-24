FactoryBot.define do
  factory :comment do
    text { "MyText" }
    commentable { nil }
  end
end
