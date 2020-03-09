require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }

  it { should validate_presence_of :user }
  it { should validate_presence_of :question }

  let(:user) { build(:user) }
  let(:question) { build(:question) }
  let(:subcsription) { build(:subscription, user: user, question: question) }
  it { expect(subcsription).to validate_uniqueness_of(:user).scoped_to(:question_id) }
end
