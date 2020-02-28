class RegistrationsController < Devise::RegistrationsController
  def create
    @user = User.new(sign_up_params)
    @user.skip_confirmation_notification!
    @user.skip_confirmation!
    if @user.save
      sign_in(@user)
      redirect_to root_path
    else
      render :new
    end
  end
end
