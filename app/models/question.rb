class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def can_modified?(user)
    true if user.id == self.user.id
  end
end
