class Answer < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  default_scope { order('best DESC, created_at') }

  belongs_to :user
  belongs_to :question, touch: true

  has_many_attached :files

  validates :body, presence: true

  after_create_commit :notify_subscribers


  def make_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.award&.update!(user: user)
    end
  end

  private

  def notify_subscribers
    NewAnswerDigestJob.perform_later(self)
  end
end
