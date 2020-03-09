class NewAnswerDigestJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswerDigestService.new.digest(answer)
  end
end
