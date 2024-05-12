require 'rails_helper'

RSpec.describe Question do
  before do
    data = {"id"=>8,
    "topic"=>"Music Trivia",
    "question_text"=>"What is the name of Rihanna's debut single?",
    "correct_answer"=>"Pon de Replay",
    "options"=>["Umbrella", "Diamonds", "Love on the Brain", "Pon de Replay"]}

    @question = Question.new(data)
  end

  describe '#initialize' do
    it 'exists and populates attributes correctly' do
      expect(@question).to be_a(Question)
      expect(@question.question_number).to eq(8)
      expect(@question.topic).to eq("Music Trivia")
      expect(@question.question_text).to eq("What is the name of Rihanna's debut single?")
      expect(@question.answer).to eq("Pon de Replay")
      expect(@question.options).to eq(["Umbrella", "Diamonds", "Love on the Brain", "Pon de Replay"])
    end
  end
end