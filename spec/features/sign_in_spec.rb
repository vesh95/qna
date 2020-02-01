require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registred user tries to sign in' do
    fill_in 'Email', with:  user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    # save_and_open_page
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistred user tries to sign in' do
    fill_in 'Email', with:  'wrong@test'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    # save_and_open_page
    expect(page).to have_content 'Invalid Email or password.'
  end
end
