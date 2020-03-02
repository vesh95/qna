require "rails_helper"

feature 'User can edit question' do
  given(:question) { create(:question, user: user) }
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit edit_question_path(question)
    end

    scenario 'edit question with valid params' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text'
      click_on 'Update Question'

      expect(page).to have_content 'Your question successfully updated'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text'
    end

    scenario 'edit question with file' do
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Update Question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'edit question with invalid params' do
      fill_in 'Title', with: ''
      fill_in 'Body', with: 'text text'
      click_on 'Update Question'

      expect(page).to have_content 'Title can\'t be blank'
    end
  end

  scenario 'Unauthenticated user tries edit question' do
    visit edit_question_path(question)
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
