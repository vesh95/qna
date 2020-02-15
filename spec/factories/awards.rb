FactoryBot.define do
  factory :award do
    sequence :title do |n|
      "Award#{n}"
    end

    user { nil }
    question { nil }
    image { fixture_file_upload("#{Rails.root}/spec/files/IMG_cat.jpg", 'image/jpg') }
  end
end
