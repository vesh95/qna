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

      scenario 'with file', js: true do
        within '.answer-form' do
          fill_in 'Body', with: 'Text text'
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Create Answer'
        end
        find('.direct-upload--complete', count: 2)
        within '.answers' do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
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

  context "mulitple sessions" do
    given!(:another_question) { create(:question)}

    scenario "answers appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('guest1') do
        visit question_path(another_question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'test text'
        click_on 'Create Answer'
        expect(page).to have_content 'test text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'test text'
      end

      Capybara.using_session('guest1') do
        expect(page).to_not have_content 'test text'
      end
    end
  end
end
