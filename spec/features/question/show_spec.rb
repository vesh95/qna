require "rails_helper"

feature 'User can view the question' do
  given!(:question) { create_list(:question, 3) }

  scenario 'that\'s selected of list' do

    visit questions_path
    click_on class: 'question-link', match: :first

    expect(page).to have_content 'MyText'
  end
end
