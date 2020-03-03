require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  let(:question) { build(:question, user: user) }
  let(:answer) { build(:answer, user: user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question, Answer, Comment }
    it { should_not be_able_to :vote, question, answer }
    it { should_not be_able_to :best, answer }
    it { should_not be_able_to :create_comment, question, answer }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, type: 'Admin') }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { build(:user) }
    let(:another) { build(:user) }
    let(:self_question) { build(:question, user: user) }
    let(:self_answer) { build(:answer, user: user) }
    let(:self_comment) { build(:comment, user: user, commentable: self_answer) }

    let(:other_question) { build(:question, user: another) }
    let(:other_answer) { build(:answer, user: another) }
    let(:other_comment) { build(:comment, user: another, commentable: self_answer) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :create, Answer, Question, Comment }

    it { should be_able_to [:update, :destroy], self_question, self_answer, self_comment }

    it { should_not be_able_to [:update, :destroy], other_question, other_answer, other_comment }

    it { should_not be_able_to :vote, self_question, self_answer }

    it { should be_able_to :create_comment, self_answer, self_question, other_question, other_answer }

    describe 'best answer' do
      let(:own_question_own_answer) { build(:answer, question: self_question, user: user) }
      let(:own_question_other_answer) { build(:answer, question: self_question, user: another) }
      let(:answer) { build(:answer) }

      it { should_not be_able_to :best, self_answer, own_question_own_answer, answer }
      it { should be_able_to :best, own_question_other_answer }
    end
  end
end
