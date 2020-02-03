require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'is author' do
    let(:user) { create(:user) }

    context 'of question' do
      let(:question) { create(:question) }

      it 'author' do
        expect(question.user.author?(question)).to eq true
      end
      it 'not author' do
        expect(user.author?(question)).to eq false
      end
    end

    context 'of answer' do
      let(:answer) { create(:answer) }

      it 'author' do
        expect(answer.user.author?(answer)).to eq true
      end

      it 'not author' do
        expect(user.author?(answer)).to eq false
      end
    end
  end
end
