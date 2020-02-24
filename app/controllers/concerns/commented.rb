module Commented
  extend ActiveSupport::Concern
  include Klassify

  included do
    before_action :set_commentable, only: :create_comment
    # after_action :broadcast_comment, olny: :create_comment
  end

  def create_comment
    @commentable.comments.create(comment_params)
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(user: current_user)
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end
end
