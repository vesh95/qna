class Comment < ApplicationRecord
  belongs_to :commentable
  belongs_to :user

  validates :text, presence: true
end
