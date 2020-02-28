class EmailConfirmationsController < Devise::ConfirmationsController

  def new; end

  def create
    email = confirmation_params[:email]
    password = Devise.friendly_token[0, 20]
    user = User.new(email: email, password: password, password_confirmation: password)

    if user.valid?
      user.send_confirmation_instructions # Тут обновляется аттрибут confirmation_token тем самым сохраняется
    else
      flash.now[:alert] = 'Enter your email'
      render :new
    end
  end

  private


  def after_confirmation_path_for(resource, user)
    user.authorizations.create!(
      provider: session[:provider],
      uid: session[:uid]
    )

    sign_in(user)
    root_path
  end

  def confirmation_params
    params.permit(:email)
  end
end
