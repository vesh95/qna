class UsersController < ApplicationController
  before_action :authenticate_user!, only: :index
  before_action :set_profile, only: :show

  def index
    @user = current_user
    @awards = current_user.awards
  end

  def show; end

  private

  def set_profile
    @user = User.find(params['id'])
    @awards = @user.awards
  end
end
