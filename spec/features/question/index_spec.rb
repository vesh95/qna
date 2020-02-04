require "rails_helper"

feature 'User can seeing all questions' do
  given!(:questions) { create_list(:question, 2, :list_of_questions) }

  scenario 'User visit questions list' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content(question.title)
    end
  end
end
