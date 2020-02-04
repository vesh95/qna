require "rails_helper"

feature 'User can view the question' do
  given!(:question) { create(:question) }

  background do
    question.answers = create_list(:answer, 2)
  end

  scenario 'that\'s selected of list' do
    visit questions_path(question)
    click_on class: 'question-link', match: :first

    expect(page).to have_content question.body

    question.answers.each { |answer| expect(page).to have_content answer.body }
  end
end
