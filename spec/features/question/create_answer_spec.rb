require "rails_helper"

feature 'User can send answer for selected question' do
  given!(:question) { create(:question) }
  given!(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'Body', with: 'Answer1'
      click_on 'Create Answer'
    end

    scenario 'tries create answer' do
      expect(page).to have_content('Your question successfully created')
      expect(page).to have_content(question.reload.answers.last.body)
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
      fill_in 'Body', with: 'Answer1'
      click_on 'Create Answer'
    end
    scenario 'tries create answer' do
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

end
