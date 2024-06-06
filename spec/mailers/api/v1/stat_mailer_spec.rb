# require "rails_helper"

# RSpec.describe Api::V1::StatMailer, type: :mailer do
#   describe 'send_stat_email' do
#     let(:game) { create(:game, topic: 'Science', number_of_questions: 3) }
#     let(:stat) { create(:stat, game: game, avg_correct_answers: 2.5) }
#     let!(:player1) { create(:player, game: game, display_name: 'Alice', answers_correct: 2) }
#     let!(:player2) { create(:player, game: game, display_name: 'Bob', answers_correct: 3) }
#     let(:mail) { described_class.send_stat_email('me@example.com', stat.id) }

#     it 'renders the headers' do
#       expect(mail.subject).to eq('Your Brain Freeze Statistics Report')
#       expect(mail.to).to eq(['me@example.com'])
#     end

#     it 'renders the body with correct content' do
#       expect(mail.body.encoded).to include('Your Brain Freeze Statistics Report')
#       expect(mail.body.encoded).to include("The group average correct answers: #{stat.avg_correct_answers}")
#       expect(mail.body.encoded).to include("Topic: #{game.topic}")
#       expect(mail.body.encoded).to include("Number of questions: #{game.number_of_questions}")
#       expect(mail.body.encoded).to include("Player Name: Alice")
#       expect(mail.body.encoded).to include("Player average correct answers: 2")
#       expect(mail.body.encoded).to include("Player Name: Bob")
#       expect(mail.body.encoded).to include("Player average correct answers: 3")
#     end

#     it 'queues the email' do
#       expect { mail.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
#     end
#   end
# end
