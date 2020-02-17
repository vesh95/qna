module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    votes.sum(:rate)
  end

  def vote_up(user)
    self.votes.create!(rate: 1, user: user)
  end

  def vote_down(user)
    self.votes.create!(rate: -1, user: user)
  end

  def vote_out(user)
    self.votes.find_by(user: user).destroy
  end
end
