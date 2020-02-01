require "rails_helper"

feature 'User can seeing all questions' do
  # QUESTION: given воссоздает новый список для каждого сценария или он всегда остается один?
  given!(:question) { create_list(:question, 3) }

  scenario 'User visit questions list' do
    visit questions_path
    expect(page).to have_content('MyString', count: 3)
  end
end
