require "rails_helper"

feature 'User can add link to question', js: true do
  given!(:user) { create(:user) }

  context 'create question' do
    background do
      sign_in(user)
      visit new_question_path
      within '#question' do
        fill_in 'Title', with: 'New question'
        fill_in 'Body', with: 'Question body'
      end
    end

    it 'with valid link' do
      fill_in 'Name', with: 'Github'
      fill_in 'Url', with: 'https://github.com/'
      click_on 'Ask'

      expect(page).to have_link 'Github', href: 'https://github.com/'
    end

    it 'with invalid link' do
      fill_in 'Name', with: 'Github'
      fill_in 'Url', with: 'fasdf&sg.'
      click_on 'Ask'

      expect(page).to have_content 'Links url is not a valid URL'
    end

    it 'with blank link fields' do
      click_on 'Ask'

      expect(page).to have_content 'Question body'
    end

    it 'with gist link' do
      fill_in 'Name', with: 'Github gist'
      fill_in 'Url', with: 'https://gist.github.com/schacon/1'
      click_on 'Ask'

      expect(page).to have_content 'This is gist.'
    end
  end

  context 'edit question' do
    given(:question) { create(:question, links: build_list(:link, 2)) }

    background do
      sign_in(user)
      visit edit_question_path(question)
      fill_in 'Title', with: 'New question'
      fill_in 'Body', with: 'Question body'
    end

    it 'tries edit link' do
      question.links.each do |link|
        expect(page).to have_field(with: link.name)
      end

      fill_in(id: "question_links_attributes_0_name", with: 'Edited link')
      click_on "Update Question"

      expect(page).to have_link 'Edited link'
    end

    it 'tries delete link' do
      first(:link, 'remove link').click
      click_on "Update Question"

      within '.links' do
        expect(page).to have_link(count: 1)
      end
    end

    it 'tries add link' do
      click_on "add link"
      find_field('Name', with: '').fill_in(with: 'New Link')
      find_field('Url', with: '').fill_in(with: 'https://new.url')
      click_on "Update Question"

      within '.links' do
        expect(page).to have_link('New Link', href: 'https://new.url')
      end
    end
  end
end
