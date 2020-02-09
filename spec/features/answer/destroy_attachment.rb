require "rails_helper"

feature 'User can destroy answer attached files', js: true do
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_files, question: question) }
  given(:user) { create(:user) }
  given(:author) { answer.user }

  context 'by author' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    it 'have attachments' do
      expect(page).to have_link 'Rakefile'
      expect(page).to have_link 'Gemfile'
      expect(page).to have_link('Delete attachment', count: 2)
    end

    it 'tries delete delete' do
      first(:link, 'Delete attach').click

      expect(page).to_not have_link 'Rakefile'
    end
  end

  context 'by another user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    it 'not see delete link' do
      expect(page).to_not have_link 'Delete attach'
    end
  end

  context 'by another user' do
    background do
      visit question_path(question)
    end

    it 'not see delete link' do
      expect(page).to_not have_link 'Delete attach'
    end
  end
end
