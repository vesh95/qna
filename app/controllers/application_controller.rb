class ApplicationController < ActionController::Base
  before_action :set_user

  private

  def set_user
    gon.user_id = current_user&.id
  end
end
