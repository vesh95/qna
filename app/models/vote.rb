class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :rate, inclusion: { in: [1, -1] }
end
