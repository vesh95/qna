class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, presence: true

  def can_modified?(user)
    true if user.id == self.user.id
  end
end
