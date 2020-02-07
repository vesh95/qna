class Answer < ApplicationRecord

  default_scope { order('best DESC, created_at') }

  belongs_to :user
  belongs_to :question

  validates :body, presence: true

  def make_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
