require "rails_helper"

feature 'Delete question' do
  given(:question) { create(:question) }

  context 'User not signed in' do

    scenario 'tries destroy question' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete question'
    end
  end

  context 'User signed in' do
    given(:user) { create(:user) }

    scenario 'trying to remove someone else\'s question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete question'
    end

    scenario 'tries to delete self question' do
      sign_in(question.user)

      visit questions_path
      expect(page).to have_content question.title

      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'Your question successfully deleted'

      visit questions_path
      expect(page).to_not have_content question.body
    end
  end
end
