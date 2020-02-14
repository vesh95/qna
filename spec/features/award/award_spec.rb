require "rails_helper"

feature 'Award', js: true do
  given(:question) { create(:question, :with_award) }
  given(:answer) { create(:answer, question: question) }
  given!(:question_owner) { create(:user, questions: [question]) }
  given!(:answer_owner) { create(:user, answers: [answer]) }

  scenario 'award user' do
    sign_in(question_owner)
    visit question_path(question)
    click_on 'Best!'

    visit user_path(answer_owner)

    expect(page).to have_content question.award.title
  end
end
