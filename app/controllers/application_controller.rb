class ApplicationController < ActionController::Base
  before_action :set_user

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_back(fallback_location: root_path, notice: exception.message) }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  private

  def set_user
    gon.user_id = current_user&.id
  end
end
