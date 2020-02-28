require "rails_helper"

feature 'Registration user' do
  background do
    visit new_user_registration_path
  end

  scenario 'with valid attributes' do
    within '#new_user' do
      fill_in 'Email', with: 'a@a'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_on 'Sign up'
    end

    expect(page).to have_content 'Sign Out'
  end

  scenario 'with valid confirmation' do
    within '#new_user' do
      fill_in 'Email', with: 'a@a'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345675'
      click_on 'Sign up'
    end

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'with invalid attributes' do
    within '#new_user' do
      click_on 'Sign up'
    end

    expect(page).to have_content 'Email can\'t be blank'
  end
end
