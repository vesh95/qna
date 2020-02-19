require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }

  it { should validate_inclusion_of(:rate).in_array([1, -1]) }

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:vote) { create(:vote, user: user, votable: question) }

  it { should validate_uniqueness_of(:user).scoped_to(:votable_id, :votable_type) }
end
