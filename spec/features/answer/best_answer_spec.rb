require "rails_helper"

feature 'Choose best answer', js: true do
  given(:question) { create(:question, answers: create_list(:answer, 2)) }

  context 'authenticate question author user' do
    background do
      sign_in(question.user)

      visit question_path(question)
    end

    it 'tryes to see best answer button' do
      expect(page).to have_link('Best!', count: 2)
    end

    it 'tries to choose best question' do
      first('.answer').click_link('Best!')

      expect(page).to have_link('Best!', count: 1)
      expect(page).to have_content("The best answer")
    end
  end

  context 'authenticate question not author user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)

      visit question_path(question)
    end

    it 'tryes to see best answer button' do
      expect(page).to_not have_link('Best!')
    end
  end

  context 'guest user' do
    it 'tryes to choose the best answer button' do
      visit question_path(question)

      expect(page).to_not have_link('Best!')
    end
  end
end
