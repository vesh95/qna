require 'rails_helper'

RSpec.describe NewAnswerDigestService do
  let!(:answer) { create(:answer, question: question) }
  let(:question) { create(:question) }
  let!(:subscriptions) { create_list(:subscription, 2, question: question)}
  let!(:another_user) { create(:user) }
  let!(:another_subscriber) { create(:user, subscriptions: create_list(:subscription, 1)) }

  it 'sends answer digest to all subscribed users only' do
    Subscription.includes(:user).where(question: question).each do |subscription|
      expect(NewAnswerDigestMailer).to receive(:send_notification).with(subscription.user, answer).and_call_original
    end

    expect(NewAnswerDigestMailer).to_not receive(:send_notification).with(another_user, answer).and_call_original
    expect(NewAnswerDigestMailer).to_not receive(:send_notification).with(another_subscriber, answer).and_call_original

    subject.digest(answer)
  end
end
