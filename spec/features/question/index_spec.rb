require "rails_helper"

feature 'User can seeing all questions' do
  given!(:question) { create_list(:question, 2) }

  scenario 'User visit questions list' do
    visit questions_path
    expect(page).to have_content('MyString', count: 2)
  end
end
