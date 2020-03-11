class DailyDigestMailer < ApplicationMailer
  def digest(user, date)
    @user = user
    @questions = Question.where(created_at: date.all_day)
    mail to: user.email, subject: 'New Questions Digest'
  end
end
