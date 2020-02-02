require "rails_helper"

feature 'Delete question answer' do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  background do
    question.answers.create!(body: 'MyTextBody', user: user)
  end

  context 'unauthenticated user' do

    scenario 'tries destroy answer' do
      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'authenticated user' do
    given(:user_not_owner) { create(:user) }
    scenario 'trying to remove someone else\'s answer' do
      sign_in(user_not_owner)

      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to have_content 'You can\'t modified this answer'
    end

    scenario 'trying to remove self answer' do
      sign_in(user)

      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to have_content 'Your answer successfully deleted'
    end
  end
end
