class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :awards

  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(resource)
    resource.user_id == self.id
  end

  def voted?(resource)
    !resource.votes.where(user_id: self.id).count.zero?
  end
end
