class AnswersController < ApplicationController
  before_action :set_question, only: %i[create new]
end
