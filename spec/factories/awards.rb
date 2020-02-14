FactoryBot.define do
  factory :award do
    user { nil }
    title { "MyString" }
    question { nil }
    image { fixture_file_upload("#{Rails.root}/spec/files/IMG_cat.jpg", 'image/jpg') }
  end
end
