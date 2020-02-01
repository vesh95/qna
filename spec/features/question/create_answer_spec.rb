require "rails_helper"

feature 'User can send answer for selected question' do
  given!(:question) { create(:question) }
  given!(:user) { create(:user) }

  describe 'Authenticated user tries create answer' do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'Body', with: 'Answer1'
      click_on 'Create Answer'
    end

    expect(page).to have_content question.answers.first.body
  end

  describe 'Unauthenticated user' do
    given!(:question) { create(:question) }
    background do
      visit question_path(question)
    end

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
