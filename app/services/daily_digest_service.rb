class DailyDigestService
  def send_digest
    return if Question.where(created_at: 1.day.ago.all_day).count.zero?

    User.find_each do |user|
      DailyDigestMailer.digest(user, 1.day.ago).deliver_now
    end
  end
end
