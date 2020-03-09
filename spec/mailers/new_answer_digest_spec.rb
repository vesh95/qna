require "rails_helper"

RSpec.describe NewAnswerDigestMailer, type: :mailer do
  let(:user) { build(:user) }
  let(:answer) { create(:answer) }
  let(:mail) { NewAnswerDigestMailer.send_notification(user, answer) }

  it "renders the headers" do
    expect(mail.subject).to eq("New Answer")
    expect(mail.to).to eq([user.email])
  end

  it "renders the body" do
    expect(mail.body.encoded).to match("New Answer")
    expect(mail.body.encoded).to match("Hello, #{user.email}")
    expect(mail.body.encoded).to match(answer.question.title)
  end
end
