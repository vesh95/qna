class DailyDigestService
  def send_digest
    @questions = Question.where(created_at: 1.day.ago.all_day)
    User.find_each do |user|
      DailyDigestMailer.digest(user, @questions)
    end
  end
end
