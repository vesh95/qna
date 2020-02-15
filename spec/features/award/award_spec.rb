require "rails_helper"

feature 'Award' do
  given(:question) { create(:question, :with_award) }
  given(:answer) { create(:answer, question: question) }
  given!(:answer_owner) { create(:user, answers: [answer]) }

  given(:question2) { create(:question, :with_award)}

  given(:question3) { create(:question, :with_award)}
  given(:answer2) { create(:answer, question: question3) }

  background do
    answer.make_best!
    answer2.make_best!
  end

  scenario 'award user' do
    sign_in(question.user)

    visit user_path(answer_owner)

    expect(page).to have_content question.award.title
    expect(page).to_not have_content question2.award.title
    expect(page).to_not have_content question3.award.title
  end
end
