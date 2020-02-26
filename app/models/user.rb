class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :awards
  has_many :authorizations, dependent: :destroy

  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  def author?(resource)
    resource.user_id == self.id
  end

  def voted?(resource)
    resource.votes.exists?(user_id: self.id)
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create!(provider: auth.provider, uid: auth.uid)
  end
end
