require 'rails_helper'

RSpec.describe DailyDigestService do
  let(:users) { create_list(:user, 2) }

  context 'questions exists' do
    let!(:questions) { create_list(:question, 2, created_at: 1.day.ago, user: users.last) }

    it 'sends daily digest to all users' do
      users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, anything).and_call_original }
      subject.send_digest
    end
  end

  context 'without today questions' do
    let!(:questions) { create_list(:question, 2, created_at: 4.day.ago, user: users.last) }

    it 'sends daily digest to all users' do
      expect(DailyDigestMailer).to_not receive(:digest)
      subject.send_digest
    end
  end

  context 'questions not exists' do
    it 'sends daily digest to all users' do
      expect(DailyDigestMailer).to_not receive(:digest)
      subject.send_digest
    end
  end
end
