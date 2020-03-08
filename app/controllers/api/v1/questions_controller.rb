class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[show answers update destroy]

  authorize_resource except: [:answers]

  def index
    @questions = Question.includes(:user).all
    render json: @questions, include: :user
  end

  def show
    render json: @question
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_resource_owner

    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @question.destroy
      render json: @question, status: :ok
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params['id'])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
