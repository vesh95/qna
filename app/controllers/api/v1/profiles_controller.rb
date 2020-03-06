class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    @user = current_resource_owner
    authorize! :read, @user
    render json: @user
  end

  def index
    authorize! :read, User
    @users = User.where.not(id: current_resource_owner.id)
    render json: @users
  end
end
