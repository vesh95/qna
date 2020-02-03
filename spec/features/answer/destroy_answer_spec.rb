require "rails_helper"

feature 'Delete question answer' do
  given(:answer) { create(:answer) }
  given(:user) { create(:user) }

  context 'unauthenticated user' do

    scenario 'tries destroy answer' do
      visit question_path(answer.question)

      expect(page).to_not have_content 'Delete answer'
    end
  end

  context 'authenticated user' do
    scenario 'trying to remove someone else\'s answer' do
      sign_in(user)
      visit question_path(answer.question)

      expect(page).to_not have_content 'Delete answer'
    end

    scenario 'trying to remove self answer' do
      sign_in(answer.user)
      visit question_path(answer.question)

      expect(page).to have_content answer.body

      click_on 'Delete answer'

      expect(page).to have_content 'Your answer successfully deleted'
    end
  end
end
