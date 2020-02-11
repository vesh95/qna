require "rails_helper"

feature 'User can add link to question', js: true do
  given!(:user) { create(:user) }

  context 'create question' do
    background do
      sign_in(user)      
      visit new_question_path
      fill_in 'Title', with: 'New question'
      fill_in 'Body', with: 'Question body'
    end

    it 'with valid link' do
      fill_in 'Name', with: 'Github'
      fill_in 'Url', with: 'https://github.com/'
      click_on 'Ask'

      expect(page).to have_link 'Github', href: 'https://github.com/'
    end

    it 'with invalid link' do
      fill_in 'Name', with: 'Github'
      fill_in 'Url', with: 'https://.com/'
      click_on 'Ask'

      expect(page).to have_content 'Invalid Link'
    end

    it 'with blank fields' do
      click_on 'Ask'

      expect(page).to have_content 'Question body'
    end
  end

  context 'edit question' do
    given(:question) { create(:question) }
    background do
      sign_in(user)      
      visit edit_question_path(question)
      fill_in 'Title', with: 'New question'
      fill_in 'Body', with: 'Question body'
    end

    it 'tries edit link'
    it 'tries delete link'
    it 'delete link'
  end

end