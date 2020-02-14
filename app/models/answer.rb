class Answer < ApplicationRecord

  default_scope { order('best DESC, created_at') }

  belongs_to :user
  belongs_to :question

  has_many :links, as: :linkable, dependent: :destroy

  has_many_attached :files

  validates :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  def make_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      user.awards << question.award unless question.award.nil?
    end
  end
end
