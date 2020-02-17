require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'linkable'
  it_behaves_like 'votable' do
    let(:votable) { create(:question) }
  end

  it { should belong_to :user }

  it { should have_one(:award).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
