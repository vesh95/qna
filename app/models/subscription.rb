class Subscription < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :user, :question, presence: true
  validates :user, uniqueness: { scope: :question_id }
end
