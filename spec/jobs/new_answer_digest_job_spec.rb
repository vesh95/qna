require 'rails_helper'

RSpec.describe NewAnswerDigestJob, type: :job do
  let(:answer) { create :answer }
  let(:service) { double('NewAnswerDigestService') }

  before { allow(NewAnswerDigestService).to receive(:new).and_return(service) }

  it 'calls NewAnswerDigestService#send_notification' do
    expect(service).to receive(:digest)
    NewAnswerDigestJob.perform_now(answer)
  end
end
