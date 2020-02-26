require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:awards) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }


  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#voted?' do
    let(:user) { build(:user) }
    let!(:question) { build(:question) }
    let!(:answer) { build(:answer) }

    let!(:voted_question) { build(:question) }
    let!(:vote) { create(:vote, user: user, votable: voted_question) }

    it 'resource is not voted' do
      expect(user).to_not be_voted(question)
    end

    it 'resource is voted' do
      expect(user).to be_voted(voted_question)
    end
  end

  describe 'is author' do
    let(:user) { create(:user) }

    context 'of question' do
      let(:question) { create(:question) }

      it 'author' do
        expect(question.user).to be_author(question)
      end

      it 'not author' do
        expect(user).to_not be_author(question)
      end
    end

    context 'of answer' do
      let(:answer) { create(:answer) }

      it 'author' do
        expect(answer.user).to be_author(answer)
      end

      it 'not author' do
        expect(user).to_not be_author(answer)
      end
    end
  end
end
