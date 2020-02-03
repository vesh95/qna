class User < ApplicationRecord
  has_many :questions
  has_many :answers

  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(resource)
    resource.user == self
  end
end
