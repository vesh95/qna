require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }

  it { should validate_inclusion_of(:rate).in_array([1, -1]) }

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:vote) { create(:vote, user: user, votable: question) }

  it 'should validate uniquesness of vote' do
    vote = Vote.new(user: user, rate: 1, votable: question)
    expect(vote).not_to be_valid
  end
end
