require "rails_helper"

feature 'Delete question' do
  given(:question) { create(:question) }

  describe 'User not signed in' do

    scenario 'tries destroy question' do
      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  describe 'User signed in' do
    background do
      given(:user) { create(:user) }
      sign_in(user)
    end

    scenario 'trying to remove someone else\'s question'
    scenario 'tries to delete self question'
  end
end
