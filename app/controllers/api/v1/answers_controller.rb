class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: :create
  before_action :set_answer, except: :create

  authorize_resource

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
    @question = Question.with_attached_files.find(params['question_id'])
  end

  def set_answer
    @answer = Answer.find(params['id'])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
