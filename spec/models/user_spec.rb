require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:awards) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#voted?' do
    let(:user) { build(:user) }
    let!(:question) { build(:question) }
    let!(:answer) { build(:answer) }

    let!(:voted_question) { build(:question) }
    let!(:vote) { create(:vote, user: user, votable: voted_question) }

    it 'resource is not voted' do
      expect(user.voted?(question)).to be_falsy
    end

    it 'resource is voted' do
      expect(user.voted?(voted_question)).to be_truthy
    end
  end

  describe 'is author' do
    let(:user) { create(:user) }

    context 'of question' do
      let(:question) { create(:question) }

      it 'author' do
        expect(question.user.author?(question)).to be_truthy
      end
      it 'not author' do
        expect(user.author?(question)).to be_falsy
      end
    end

    context 'of answer' do
      let(:answer) { create(:answer) }

      it 'author' do
        expect(answer.user.author?(answer)).to be_truthy
      end

      it 'not author' do
        expect(user.author?(answer)).to be_falsy
      end
    end
  end
end
