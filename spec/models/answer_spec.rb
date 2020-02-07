require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question}
  it { should belong_to :user}

  it { should validate_presence_of :body }

  context '#make_best' do
    let(:question) { create(:question) }
    let!(:answer1) { create(:answer, question: question) }
    let(:answer2) { create(:answer, question: question) }

    before { answer1.make_best! }

    it 'makes answer the best' do
      expect(answer1.reload).to be_best
      expect(answer2.reload).to_not be_best
    end

    it 're-make_best answer' do
      answer2.make_best!
      expect(answer2.reload).to be_best
      expect(answer1.reload).to_not be_best
    end
  end
end
