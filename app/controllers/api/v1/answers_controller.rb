class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[index create]
  before_action :set_answer, except: %i[index create]

  authorize_resource

  def index
    @answers = @question.answers
    render json: @answers, include: 'user'
  end

  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, status: :ok
    else
      render json: { errors: @answer }, status: :unprocessable_entity
    end
  end

  def destroy
    if @answer.destroy
      render json: @answer, status: :ok
    else
      render json: @answer, status: :unprocessable_entity
    end
  end

  private

  def set_question
    @question = Question.includes(:user).with_attached_files.find(params['question_id'])
  end

  def set_answer
    @answer = Answer.includes(:user).find(params['id'])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
