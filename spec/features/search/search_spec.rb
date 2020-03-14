require 'sphinx_helper'

feature 'User can search resources' do
  let(:question_user) { create(:user) }
  let(:answer_user) { create(:user) }
  let(:question) { create(:question, title: 'Title question', body: 'Question body', user: question_user) }
  let!(:answer) { create(:answer, body: 'Answer body', user: answer_user, question: question) }
  let!(:comment) { create(:comment, user: question_user, commentable: question, text: 'Comment body') }

  background { visit root_path }

  scenario 'with all resources', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '#search' do
        fill_in 'Query', with: 'body'
        find('#search_scope').select 'All'
        click_on 'Search'
      end

      expect(page).to have_content 'Comment body'
      expect(page).to have_content 'Question body'
      expect(page).to have_content 'Answer body'

      within '#search' do
        fill_in 'Query', with: 'user'
        find('#search_scope').select 'All'
        click_on 'Search'
      end

      expect(page).to have_content 'user1'
      expect(page).to have_content 'user2'
    end
  end # scenario with all resources

  scenario 'with question resource', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '#search' do
        fill_in 'Query', with: 'body'
        find('#search_scope').select 'Question'
        click_on 'Search'
      end

      expect(page).to have_content 'Question body'
      expect(page).to_not have_content 'Comment body'
      expect(page).to_not have_content 'Answer body'
      expect(page).to have_content question_user.email
      expect(page).to_not have_content answer_user.email
    end
  end

  scenario 'with answer resource', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '#search' do
        fill_in 'Query', with: 'body'
        find('#search_scope').select 'Answer'
        click_on 'Search'
      end

      expect(page).to have_content 'Answer body'
      expect(page).to_not have_content 'Comment body'
      expect(page).to_not have_content 'Question body'
      expect(page).to_not have_content question_user.email
      expect(page).to have_content answer_user.email
    end
  end

  scenario 'with comment resource', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '#search' do
        fill_in 'Query', with: 'body'
        find('#search_scope').select 'Comment'
        click_on 'Search'
      end

      expect(page).to have_content 'Comment body'
      expect(page).to_not have_content 'Answer body'
      expect(page).to_not have_content 'Question body'
      expect(page).to have_content question_user.email
      expect(page).to_not have_content answer_user.email
    end
  end

  scenario 'with user resource', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '#search' do
        fill_in 'Query', with: 'user'
        find('#search_scope').select 'User'
        click_on 'Search'
      end

      expect(page).to_not have_content 'Comment body'
      expect(page).to_not have_content 'Answer body'
      expect(page).to_not have_content 'Question body'
      expect(page).to have_content question_user.email
      expect(page).to have_content answer_user.email
    end
  end
end
