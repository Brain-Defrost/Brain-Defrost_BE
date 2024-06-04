require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'invite' do
    let(:mail) { UserMailer.create_invite('me@example.com', 'friend@example.com', Time.now) }

    it 'renders the headers' do
      expect(mail.subject).to eq('You have been invited by me@example.com')
      expect(mail.to).to eq(['friend@example.com'])
      expect(mail.from).to eq(['me@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(read_fixture('invite').join)
    end

    it 'queues the email' do
      expect { mail.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
