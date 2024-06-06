require 'rails_helper'

RSpec.describe StatSenderJob, type: :job do
  let(:game) { create(:game) }
  let(:stat_id) { create(:stat, game: game).id }
  let(:email) { 'test@example.com' }

  it 'sends an email' do
    expect {
      described_class.perform_async(email, stat_id)
    }.to change{ Sidekiq::Queue.new('mailers').size }.by(1)
  end
end
