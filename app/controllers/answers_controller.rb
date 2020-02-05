class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :set_question, only: %i[create new]
  before_action :set_answer, only: %i[edit update destroy]

  def edit; end

  def create
    @answer = @question.answers.create(answer_params)
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer successfully deleted'
    else
      flash[:alert] = 'You can\'t modified this answer'
    end
    redirect_to @answer.question
  end

  private

  def set_question
    @question = Question.find(params['question_id'])
  end

  def set_answer
    @answer = Answer.find(params['id'])
  end

  def answer_params
    params.require(:answer).permit(:body).merge(user: current_user)
  end
end
