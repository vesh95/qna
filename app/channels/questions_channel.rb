class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'questions_channel'
  end
end
