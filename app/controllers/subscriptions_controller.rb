class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create destroy]

  authorize_resource

  def create
    unless current_user.subscribed?(@question)
      @subscription = current_user.subscribe!(@question)
      flash[:notice] = 'Subscribed successfully'
    else
      flash[:alert] = 'Already subscribed'
    end
  end

  def destroy
    if current_user.subscribed?(@question)
      current_user.unsubscribe!(@question)
      flash[:notice] = 'Unsubscribe successfully'
    else
      flash[:alert] = 'Already unsubscribed'
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end
end
