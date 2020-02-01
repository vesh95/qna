require "rails_helper"

feature 'Registration user' do
  background do
    visit new_user_registration_path
  end

  scenario 'with valid attributes' do
    fill_in 'Email', with: 'a@a'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Sign Out'
  end

  scenario 'with invalid attributes' do
    click_on 'Sign up'

    expect(page).to have_content 'Email can\'t be blank'
  end
end
