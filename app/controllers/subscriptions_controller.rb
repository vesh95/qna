class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]

  authorize_resource

  def create
    if @subscription = current_user.subscribe!(@question)
      flash[:notice] = 'Subscribed successfully'
    else
      flash[:alert] = 'Already subscribed'
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    if @subscription.destroy
      flash[:notice] = 'Unsubscribe successfully'
    else
      flash[:alert] = 'Already unsubscribed'
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
