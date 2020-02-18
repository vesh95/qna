require "rails_helper"

RSpec.shared_examples "linkable" do
  it { should have_many(:links).dependent(:destroy) }
  it { should accept_nested_attributes_for :links }
end

RSpec.shared_examples "votable" do
  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { build(:user) }
  let!(:votes) { create_list(:vote, 3, votable: votable)}

  it '#rating' do
    expect(votable.rating).to eq 3
  end

  it '#vote_up' do
    expect { votable.vote_up!(user) }.to change(votable, :rating).by(1)
  end

  it '#vote_down' do
    expect { votable.vote_down!(user) }.to change(votable, :rating).by(-1)
  end

  it '#vote_out' do
    expect { votable.vote_out(votes.last.user) }.to change(votable, :rating).by(-1)
  end
end
