require "rails_helper"

feature 'User can log out' do
  given(:user) { create(:user) }

  scenario 'Log out' do
    sign_in(user)

    visit root_path
    click_on 'Sign Out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
