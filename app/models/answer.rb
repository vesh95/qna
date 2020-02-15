class Answer < ApplicationRecord
  include Linkable

  default_scope { order('best DESC, created_at') }

  belongs_to :user
  belongs_to :question

  has_many_attached :files

  validates :body, presence: true


  def make_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.award&.update!(user: user)
    end
  end

end
