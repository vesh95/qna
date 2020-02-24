require "rails_helper"

feature 'Commentable', js: true do
  given!(:question) { create(:question) }
  given!(:question1) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  context 'question' do
    scenario "comments appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(question.user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('guest1') do
        visit question_path(question1)
      end

      Capybara.using_session('user') do
        within '#question' do
          fill_in 'Text', with: 'Comment for question'
          click_on 'Create Comment'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Comment for question'
      end

      Capybara.using_session('guest1') do
        expect(page).to_not have_content 'Comment for question'
      end
    end
  end

  context 'answer' do
    scenario "comments appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(question.user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('guest1') do
        visit question_path(question1)
      end

      Capybara.using_session('user') do
        within '.answer' do
          fill_in 'Text', with: 'Comment for answer'
          click_on 'Create Comment'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Comment for answer'
      end

      Capybara.using_session('guest1') do
        expect(page).to_not have_content 'Comment for answer'
      end
    end
  end

end
