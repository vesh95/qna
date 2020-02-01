require "rails_helper"

feature 'Delete question' do
  given(:question) { create(:question) }

  context 'User not signed in' do

    scenario 'tries destroy question' do
      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'User signed in' do
    given(:user) { create(:user) }

    scenario 'trying to remove someone else\'s question' do
      sign_in(user)

      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'You can\'t modified this question'
    end

    scenario 'tries to delete self question' do
      sign_in(question.user)

      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'Your question successfully deleted'
    end
  end
end
