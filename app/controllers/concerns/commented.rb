module Commented
  extend ActiveSupport::Concern
  include Klassify

  included do
    before_action :set_commentable, only: :create_comment
    after_action :broadcast_comment, only: :create_comment
  end

  def create_comment
    @comment = @commentable.comments.create(comment_params)
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(user: current_user)
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def broadcast_comment
    return if @comment.errors.any?

    question_id = @comment.commentable_type == 'Question' ? @comment.commentable_id : @comment.commentable.question_id

    ActionCable.server.broadcast("question/#{question_id}/comments", data: {
      type: @comment.commentable_type.downcase,
      id: @comment.commentable_id,
      user: @comment.user,
      text: @comment.text
    })
  end
end
