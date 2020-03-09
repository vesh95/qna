require 'rails_helper'

feature 'Subscribe/unscribe question' do
  given(:user) { create(:user) }

  describe 'user shold be subscribed on question after create' do
    background { sign_in(user) }

    scenario 'create question' do
      visit root_path

      click_on 'Ask question'
      within '#question' do
        fill_in 'Title', with: 'QuestionTitle'
        fill_in 'Body', with: 'QuestionText'
      end
      click_on 'Ask'

      expect(page).to have_link 'Unsubscribe'
    end
  end

  describe 'user can subscribe/unscribe from question' do
    let(:question) { create(:question, user: user) }
    let(:another_user) { create(:user) }

    background { sign_in(another_user) }

    scenario 'subscribe/unscribe question', js: true do
      visit question_path(question)

      expect(page).to have_link('Subscribe')
      click_on 'Subscribe'

      expect(page).to have_link('Unsubscribe')
      click_on 'Unsubscribe'

      expect(page).to have_link('Subscribe')
    end
  end
end
