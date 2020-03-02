class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :awards, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  # :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  def admin?
    self.type == 'Admin'
  end

  def author?(resource)
    resource.user_id == self.id
  end

  def voted?(resource)
    resource.votes.exists?(user_id: self.id)
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def create_authorization!(auth)
    authorizations.create!(provider: auth.provider, uid: auth.uid)
  end
end
