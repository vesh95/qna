require 'rails_helper'

feature 'User can sign in with oauth' do
  context 'can sign in user' do
    background { visit new_user_session_path }

    scenario 'throuth Github' do
      expect(page).to have_content 'Sign in with GitHub'

      click_on 'Sign in with GitHub'

      expect(page).to have_content("gituser")
      expect(page).to have_content("Sign Out")
    end

    scenario 'throuth Vkontakte' do
      expect(page).to have_content 'Sign in with Vkontakte'

      click_on 'Sign in with Vkontakte'

      expect(page).to have_content("vk@vk")
      expect(page).to have_content("Sign Out")
    end

    scenario "can handle authentication error" do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      page.should have_content("Sign in with GitHub")
      click_link "Sign in"
      page.should have_content(/because "Invalid credentials"/)
    end
  end
end
