require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:awards) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  context 'subscriptions' do
    let!(:question) { create(:question) }
    let(:user) { create(:user) }
    let(:subscription) { user.subscribe!(question) }

    describe '#subscribe!' do
      it 'creates subscription' do
        expect { user.subscribe!(question) }.to change(Subscription, :count).by(1)
      end

      it 'attributes must match' do
        expect(subscription.user.id).to eq user.id
        expect(subscription.question.id).to eq question.id
      end
    end

    describe '#unsubscribe!' do
      let!(:subscription) { create(:subscription, user: user, question: question) }

      it 'deletes subscription' do
        expect { user.unsubscribe!(question) }.to change(Subscription, :count).by(-1)
      end

      it 'attributes must match' do
        expect(subscription.user.id).to eq user.id
        expect(subscription.question.id).to eq question.id
      end
    end

    describe '#subscribed?' do
      let!(:subscription) { create(:subscription, user: user, question: question)}
      let(:another_question) { create(:question) }

      it 'user have subscription' do
        expect(user.subscribed?(question)).to be_truthy
      end

      it 'user to not have another subscription' do
        expect(user.subscribed?(another_question)).to be_falsy
      end

    end
  end

  describe '#admin?' do
    let(:admin) { build(:user, type: 'Admin') }
    let(:user) { build(:user) }

    it { expect(admin).to be_admin }
    it { expect(user).to_not be_admin }
  end

  describe '.find_for_oauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('FindForOauth') }

    it 'calls FindForOauth' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#create_authorization!' do
    let(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }

    it { expect(user.create_authorization!(auth)).to be_instance_of(Authorization) }
    it 'change authorizations count by 1' do
      expect{ (user.create_authorization!(auth)) }.to change(Authorization, :count).by(1)
    end

    it do
      expect(user.create_authorization!(auth))
        .to have_attributes(auth)
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
