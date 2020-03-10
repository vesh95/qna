class DailyDigestService
  def send_digest
    @questions = Question.where(created_at: 1.day.ago.all_day)
    return if @questions.empty?

    User.find_each do |user|
      DailyDigestMailer.digest(user, @questions.to_a).deliver_later
    end
  end
end
