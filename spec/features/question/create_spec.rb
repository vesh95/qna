require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As sn authenticated user
  I'd like to be able to ask question
} do

  given(:user) { User.create!(email: 'user@test', password: '12345678') }

  background { visit new_user_session_path }

  scenario 'Authenticated user asks a question' do

    fill_in 'Email', with:  user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text'
  end

  scenario 'Authenticated user asks a question wit errors' do
    fill_in 'Email', with:  user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'

    click_on 'Ask'

    # save_and_open_page

    expect(page).to have_content "Title can't be blank"
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
