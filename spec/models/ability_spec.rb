require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, type: 'Admin') }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:another) { create(:user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Comment }

    it { should be_able_to [:update, :destroy], build(:question, user: user) }
    it { should be_able_to [:update, :destroy], build(:answer, user: user) }
    it { should be_able_to [:update, :destroy], build(:comment, user: user) }

    it { should_not be_able_to [:update, :destroy], build(:question, user: another) }
    it { should_not be_able_to [:update, :destroy], build(:answer, user: another) }
    it { should_not be_able_to [:update, :destroy], build(:comment, user: another) }
  end
end
