class FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    elsif email
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)

      user.transaction do
        user.skip_confirmation!
        user.save!
        user.authorizations.create!(provider: auth.provider, uid: auth.uid)
      end
    else
      user = User.new
    end

    user
  end
end
