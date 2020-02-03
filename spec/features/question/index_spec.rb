require "rails_helper"

feature 'User can seeing all questions' do
  given!(:question) { create_list(:question, 2, :list_of_questions) }

  scenario 'User visit questions list' do
    visit questions_path
    2.times do |n|
      expect(page).to have_content("Qusetion#{n+1}")
    end
  end
end
