require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'linkable'
  it_behaves_like 'commentable'
  it_behaves_like 'votable' do
    let!(:votable) { create(:answer) }
  end


  it { should belong_to :question}
  it { should belong_to :user}

  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  let(:question) { create(:question) }
  let!(:answer1) { create(:answer, question: question) }
  let!(:answer2) { create(:answer, question: question) }
  let!(:award) { create(:award, question: question) }

  describe '#make_best' do
    before { answer1.make_best! }

    it 'makes answer the best' do
      expect(answer1.reload).to be_best
      expect(answer2.reload).to_not be_best
    end

    it 're-make_best answer' do
      expect(answer1.reload.user.awards).to be_include(question.award)

      answer2.make_best!
      answer2.reload
      answer1.reload

      expect(answer2).to be_best
      expect(answer2.user.awards).to be_include(question.award)
      expect(answer1).to_not be_best
      expect(answer1.user.awards).to_not be_include(question.award)
    end
  end

  describe 'ordering' do
    let!(:best_answer) { create(:answer, best: true, question: question) }

    it 'best answer sould be first' do
      question.answers.reload
      expect(question.answers).to eq [best_answer, answer1, answer2]
    end
  end
end
