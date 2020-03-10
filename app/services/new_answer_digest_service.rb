class NewAnswerDigestService
  def digest(answer)
    users = answer.question.subscribers

    users.find_each do |user|
      NewAnswerDigestMailer.send_notification(user, answer).deliver_later
    end
  end
end
