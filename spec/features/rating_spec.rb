require "rails_helper"

feature 'User can vote question/answer' do
  given!(:question) { create(:question) }

  describe 'users abilities' do
    scenario 'by user'
    scenario 'by guest'
    scenario 'by voted user'
    scenario 'by unvoted user'
  end

  describe 'voting' do
    given!(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'success voteup' do
      within "#question" do
        expect(page).to have_link '+'
        expect(page).to have_link '-'
        click_on '+'
        expect(page).to have_content 'Rating: 1'
        expect(page).to have_link 'revote'
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
      end
    end

    scenario 'success votedown' do
      within "#question" do
        expect(page).to have_link '+'
        expect(page).to have_link '-'
        click_on '-'
        expect(page).to have_content 'Rating: -1'
        expect(page).to have_link 'revote'
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
      end
    end

    scenario 'success voteout' do
      question.vote_down
      within "#question" do
        expect(page).to have_link 'revote'
        click_on 'revote'
        expect(page).to have_content 'Rating: 0'
        expect(page).to_have have_link ['+', '-']
      end
    end
  end

end
