class NewAnswerDigestService
  def digest(answer)
    users = User.joins(:subscriptions).where(subscriptions: { question_id: answer.question.id } )

    users.find_each do |user|
      NewAnswerDigestMailer.send_notification(user, answer).deliver_later
    end
  end
end
