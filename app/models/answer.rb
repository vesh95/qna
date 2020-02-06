class Answer < ApplicationRecord

  default_scope { order('best DESC, created_at') }

  belongs_to :user
  belongs_to :question

  validates :body, presence: true
  validates :best, :inclusion => { in: [true, false] }

  scope :best, -> { where(best: true) }
end
