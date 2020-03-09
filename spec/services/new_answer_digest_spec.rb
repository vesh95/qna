require 'rails_helper'

RSpec.describe NewAnswerDigestService do
  let!(:answer) { create(:answer, question: question) }
  let(:question) { create(:question) }
  let!(:subscriptions) { create_list(:subscription, 2, question: question)}

  it 'sends daily digest to all users' do
    Subscription.all.each do |subscription|
      expect(NewAnswerDigestMailer).to receive(:send_notification).with(subscription.user, answer).and_call_original
    end
    subject.digest(answer)
  end
end
