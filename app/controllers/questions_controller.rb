class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]
  after_action :broadcast_question, only: :create
  before_action :set_subscription, only: %i[show]
  after_action :broadcast_destroy_question, only: :create

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new(question: @question)
    @answer.links.new
  end

  def edit; end

  def new
    @question = Question.new
    @question.links.new
    @question.award = Award.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question, notice: 'Your question successfully updated'
    else
      render :edit
    end
  end

  def destroy
    if current_user.author?(@question)
      flash[:notice] = 'Your question successfully deleted' if @question.destroy
      broadcast_destroy_question
    else
      flash[:alert] = 'You can\'t modified this question'
    end
    redirect_to @question
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params['id'])
  end

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      files: [],
      links_attributes: [:id, :name, :url, :_destroy],
      award_attributes: [:title, :image]
    ).merge(user: current_user)
  end

  def broadcast_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions_channel', data: {
      question: ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question },
        action: :create
      ),
      action: :create
    })
  end

  def broadcast_destroy_question
    ActionCable.server.broadcast('questions_channel', data: {
      id: @question.id,
      action: :destroy
    })
  end

  def set_subscription
    @subscription = current_user&.subscriptions&.find_by(question_id: @question)
  end
end
