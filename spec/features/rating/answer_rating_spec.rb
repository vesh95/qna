require "rails_helper"

feature 'User can vote question/answer', js: true do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'users abilities' do
    scenario 'by owner' do
      sign_in(answer.user)
      visit question_path(question)

      within '.answer' do
        expect(page).to_not have_link('+')
        expect(page).to_not have_link('-')
        expect(page).to_not have_link('revote')
      end
    end

    scenario 'by guest' do
      visit question_path(question)

      within '.answer' do
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
      within ".answer" do
        click_on '+'
        expect(page).to have_content 'Rating:1'
      end
    end

    scenario 'success votedown' do
      within ".answer" do
        click_on '-'
        expect(page).to have_content 'Rating:-1'
        expect(page).to have_link 'revote'
      end
    end

    context 'voteout' do
      background do
        answer.vote_down!(user)
        visit question_path(question)
      end

      scenario 'success voteout' do
        within ".answer" do
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
