require "rails_helper"

feature 'User can view the question' do
  given!(:question) { create(:question) }

  background do
    question.answers = create_list(:answer, 3, :list_of_answers)
  end

  scenario 'that\'s selected of list' do
    visit questions_path(question)
    click_on class: 'question-link', match: :first

    expect(page).to have_content 'MyText'

    3.times { |n| expect(page).to have_content "Answer#{n+1}" }
  end
end
