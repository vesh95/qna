class AnswersController < ApplicationController
  before_action :set_question, only: %i[create new]
  before_action :set_answer, only: %i[edit update destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @answer.question
    else
      render :new
    end
  end

  private

  def set_question
    @question = Question.find(params['question_id'])
  end

  def set_answer
    @answer = Answer.find(params['id'])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
