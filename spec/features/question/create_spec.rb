require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As sn authenticated user
  I'd like to be able to ask question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
      within '#question' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text'
      end
    end

    scenario 'Asks a question' do
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text'
    end

    scenario 'asks a question with attached file' do
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'Asks a question wit errors' do
      visit new_question_path
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with award' do
      visit new_question_path
      within '#question' do
        fill_in 'Title', with: 'Title1'
        fill_in 'Body', with: 'Body1'
      end

      within '.award-fields' do
        fill_in 'Title', with: 'Award'
        attach_file 'Image', "#{Rails.root}/spec/files/IMG_cat.jpg"
      end
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created'
      expect(page).to have_content 'Title1'
      expect(page).to have_content 'Body1'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path

    expect(page).to_not have_link 'Ask question'
  end

  context "mulitple sessions" do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit new_question_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        first('#question_title').fill_in(with: 'Test question')
        fill_in 'Body', with: 'test text'
        click_on 'Ask'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end
end
