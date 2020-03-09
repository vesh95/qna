require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  let(:user) { build(:user) }
  let(:questions) { build_list(:question, 2) }
  let(:mail) { DailyDigestMailer.digest(user, questions) }
  
  it "renders the headers" do
    expect(mail.subject).to eq("New Questions Digest")
    expect(mail.to).to eq([user.email])
  end

  it "renders the body" do
    expect(mail.body.encoded).to match("New questions")
    expect(mail.body.encoded).to match("Hello #{user.email}")
    questions.pluck(:title).each do |question|
      expect(mail.body.encoded).to match(question)
    end
  end
end
