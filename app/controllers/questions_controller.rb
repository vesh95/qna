class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]

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
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :name, :url, :_destroy]).merge(user: current_user)
  end
end
