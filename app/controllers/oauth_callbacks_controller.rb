class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    sign_in_with_oauth
  end

  def vkontakte
    sign_in_with_oauth
  end

  private

  def auth
    request.env['omniauth.auth']
  end

  def sign_in_with_oauth
    @user = User.find_for_oauth(auth)

    if @user&.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name) if is_navigational_format?
    elsif @user
      session[:provider] = auth.provider
      session[:uid] = auth.uid
      redirect_to new_user_confirmation_path
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
