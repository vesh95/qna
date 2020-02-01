require "rails_helper"

feature 'Delete question answer' do
  context 'unauthenticated user' do
    scenario 'tries destroy answer'
  end

  context 'authenticated user' do
    scenario 'trying to remove someone else\'s answer'
    scenario 'trying to remove self answer'
  end
end
