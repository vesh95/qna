require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question}
  it { should belong_to :user}

  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#make_best' do
    let(:question) { create(:question) }
    let!(:answer1) { create(:answer, question: question) }
    let!(:answer2) { create(:answer, question: question) }

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

  describe 'ordering' do
    let(:question) { create(:question) }
    let!(:answer1) { create(:answer, question: question) }
    let!(:answer2) { create(:answer, question: question) }
    let!(:best_answer) { create(:answer, best: true, question: question) }

    it 'best answer sould be first' do
      question.answers.reload
      expect(question.answers).to eq [best_answer, answer1, answer2]
    end
  end
end
