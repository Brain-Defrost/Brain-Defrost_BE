require 'rails_helper'

RSpec.describe StatSenderJob, type: :job do
  before do
    Sidekiq::Testing.fake!
  end

  let(:game) { create(:game) }
  let(:stat_id) { create(:stat, game: game).id }
  let(:email) { 'test@example.com' }
  
  it 'queues the job' do
    expect {
      described_class.perform_async(email, stat_id)
    }.to change { Sidekiq::Queues['default'].size }.by(1)
  end
end
