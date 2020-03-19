class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[show]
  before_action :set_question, only: %i[create new]
  before_action :set_answer, only: %i[edit update destroy best show]
  after_action :broadcast_answer, only: %i[create]

  authorize_resource

  def edit; end

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  def best
    @question = @answer.question
    if current_user.author?(@answer.question)
      @answer.make_best!
    else
      render status: 401
    end
  end

  def show; end

  private

  def set_question
    @question = Question.with_attached_files.find(params['question_id'])
  end

  def set_answer
    @answer = Answer.find(params['id'])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def broadcast_answer
    return if @answer.errors.any?

    QuestionAnswersChannel.broadcast_to(@answer.question, data: {
      answer: @answer,
    })
  end
end
