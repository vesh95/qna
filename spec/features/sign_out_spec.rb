require "rails_helper"

feature 'User can log out' do
  given(:user) { create(:user) }

  scenario 'Log out' do
    sign_in(user)

    visit root_path
    click_on 'Sign Out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Guest log out' do
    visit root_path
    expect(page).to_not have_content 'Sign Out'
  end
end
