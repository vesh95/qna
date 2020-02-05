require "rails_helper"

feature 'User can send answer for selected question' do
  given!(:question) { create(:question) }
  given!(:user) { create(:user) }

  context 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)

    end

    describe 'tries create answer' do
      scenario 'with valid attributes', js: true do
        fill_in 'Body', with: 'Answer1'
        click_on 'Create Answer'

        expect(page).to have_content('Answer1')
      end

      scenario 'with invalid attributes', js: true do
        fill_in 'Body', with: ''
        click_on 'Create Answer'
        expect(page).to have_content("Body can't be blank")
      end
    end

  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end

    scenario 'page has not form' do
      expect(page).to_not have_button("Create Answer")
    end
  end

end
