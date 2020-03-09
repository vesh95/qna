class NewAnswerDigestMailer < ApplicationMailer
  def send_notification(user, answer)
    @user = user
    @answer = answer
    @question = answer.question

    mail to: @user.email, subject: 'New Answer'
  end
end
