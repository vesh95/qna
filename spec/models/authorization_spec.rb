require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to :user }

  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }

  let(:authorization) { build(:authorization, user: build(:user)) }
  it { expect(authorization).to validate_uniqueness_of(:provider).scoped_to(:uid) }
end
