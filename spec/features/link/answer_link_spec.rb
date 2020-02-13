require "rails_helper"

feature 'User can add link to answer', js: true do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  background { sign_in(user) }

  context 'create answer' do
    background do
      visit question_path(question)
      within '.answer-form' do
        fill_in 'Body', with: 'Answer 1'
      end
    end

    it 'with valid link' do
      within '.answer-form' do
        fill_in 'Name', with: 'Github'
        fill_in 'Url', with: 'https://github.com/'
        click_on 'Create Answer'
      end

      within '.answers' do
        expect(page).to have_link 'Github', href: 'https://github.com/'
      end
    end

    it 'with invalid link' do
      within '.answer-form' do
        fill_in 'Name', with: 'Github'
        fill_in 'Url', with: 'fasdf&sg.'
        click_on 'Create Answer'
      end

      expect(page).to have_content 'Links url is not a valid URL'
    end

    it 'with blank link fields' do
      click_on 'Create Answer'

      expect(page).to have_content 'Answer 1'
    end

    it 'with gist link'
  end

  context 'with edit answer' do
    given!(:answer) { create(:answer, :with_link, question: question, user: user) }

    background do
      visit question_path(question)
    end

    it 'tries edit link' do
      expect(page).to have_field(with: answer.links[0].name)

      within ".answers .answer" do
        click_on 'Edit'
        first('.nested-fields').fill_in('Name', with: 'Edited Link')
        click_on('Update Answer')
      end

      expect(page).to have_content 'Edited Link'
    end

    it 'tries edit link with error' do
      expect(page).to have_field(with: answer.links[0].name)

      within ".answers .answer" do
        click_on 'Edit'
        first('.nested-fields').fill_in('Url', with: 'nolink=+!')
        click_on('Update Answer')
      end

      expect(page).to have_content 'Links url is not a valid URL'
    end

    it 'tries delete link' do
      within '.answers .answer' do
        click_on 'Edit'
        first(:link, 'remove link').click
        click_on "Update Answer"
      end

      expect(page).to_not have_link(answer.links[0].name)
    end

    it 'tries add link' do
      within '.answer' do
        click_on 'Edit'
        click_on "add link"
        find_field('Name', with: '').fill_in(with: 'New Link')
        find_field('Url', with: '').fill_in(with: 'https://new.url')
        click_on "Update Answer"

        within '.links' do
          expect(page).to have_link(count: 2)
        end
      end      
    end
  end
  
  context 'not answer owner user' do
    given!(:answer) { create(:answer, :with_link, question: question) }

    it 'tries edit link' do
      visit question_path(question)

      within '.answers .answer' do
        expect(page).to_not have_button('Update Anser')
      end
    end
  end
end