require "rails_helper"

feature 'User can vote question/answer', js: true do
  given!(:question) { create(:question) }

  describe 'users abilities' do
    scenario 'by owner' do
      sign_in(question.user)
      visit question_path(question)

      within '#question' do
        expect(page).to_not have_link('+')
        expect(page).to_not have_link('-')
        expect(page).to_not have_link('revote')
      end
    end

    scenario 'by guest' do
      visit question_path(question)

      within '#question' do
        expect(page).to_not have_link('+')
        expect(page).to_not have_link('-')
        expect(page).to_not have_link('revote')
      end
    end
  end

  describe 'voting' do
    given!(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'success voteup' do
      within "#question" do
        click_on '+'
        expect(page).to have_content 'Rating:1'
      end
    end

    scenario 'success votedown' do
      within "#question" do
        click_on '-'
        expect(page).to have_content 'Rating:-1'
        expect(page).to have_link 'revote'
      end
    end

    context 'voteout' do
      background do
        question.vote_up!(user)
        question_path(question)
      end

      scenario 'success voteout' do
        within "#question" do
          expect(page).to have_link 'revote'
          click_on 'revote'
          expect(page).to have_content 'Rating:0'
          expect(page).to have_link '+'
          expect(page).to have_link '-'
        end
      end
    end
  end

end
