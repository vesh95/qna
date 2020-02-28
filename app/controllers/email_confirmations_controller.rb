class EmailConfirmationsController < Devise::ConfirmationsController

  def new; end

  def create
    email = confirmation_params[:email]
    password = Devise.friendly_token[0, 20]
    user = User.first_or_create(email: email) do |user|
      user.skip_confirmation_notification!
      user.email = email
      user.password = password
    end

    if user.valid?
      user.send_confirmation_instructions # Тут обновляется аттрибут confirmation_token тем самым сохраняется
    else
      flash.now[:alert] = 'Enter your email'
      render :new
    end
  end

  def show
    super do |resource|
      resource.authorizations.create!(
        provider: session[:provider],
        uid: session[:uid]
      )
    end
  end

  private


  def after_confirmation_path_for(resource, user)
    sign_in(user)
  end

  def confirmation_params
    params.permit(:email)
  end
end
