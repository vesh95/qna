class Question < ApplicationRecord
  include Linkable
  include Votable

  belongs_to :user

  has_one :award, dependent: :destroy
  has_many :answers, dependent: :destroy

  has_many_attached :files

  validates :title, :body, presence: true

  accepts_nested_attributes_for :award, reject_if: :all_blank
end
