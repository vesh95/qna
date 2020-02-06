require "rails_helper"

feature 'Edit question answer', js: true do
  given!(:answer) { create(:answer) }

  context 'by owner user' do
    background do
      sign_in(answer.user)
      visit question_path(answer.question)
    end

    it 'edit button is rendered' do
      within '.answers' do
        expect(page).to have_link('Edit')
        # REVIEW: Не смог включить стили в тесте
        # page.assert_selector('.edit.hidden')
      end
    end

    it 'with valid attributes' do
      click_on 'Edit'

      within '.answers' do
        find("#answer_body-#{answer.id}").fill_in(with: 'edited answer')
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
      end
    end

    it 'with invalid attributes' do
      click_on 'Edit'

      within '.answers' do
        find("#answer_body-#{answer.id}").fill_in(with: '')
        click_on 'Save'
        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  context 'by not owner user' do
    given(:not_owner_user) { create(:user) }

    background do
      sign_in(not_owner_user)
      visit question_path(answer.question)
    end

    it 'edit button not rendered' do
      expect(page).to_not have_content 'Edit'
    end
  end

  context 'guest user' do
    background do
      visit question_path(answer.question)
    end

    it 'edit button not rendered' do
      expect(page).to_not have_content 'Edit'
    end
  end
end
