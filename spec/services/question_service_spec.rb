require 'rails_helper'

RSpec.describe QuestionService do
  before(:each) do
    number = 8
    topic = "music"

    @question_service = QuestionService.new(number, topic)
  end
  describe '#initialize' do
    it 'exists and populates attributes correctly' do
      expect(@question_service).to be_a(QuestionService)
      expect(@question_service.query).to eq("Write 8 trivia questions and write the answer below each question. Make the questions about music, and phrase the answers in two words or less")
    end
  end

  describe '#call' do
    xit 'returns generated trivia questions' do
    end
  end
end