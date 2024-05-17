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
      expect(@question.options).to be_an(Array)
      expect(@question.options.length).to eq(4)
      expect(@question.options.include?("Pon de Replay")).to eq(true)
    end

    it 'places the correct answer in a different location every time' do
      data_2 = {"id"=>9,
      "topic"=>"Chess Trivia",
      "question_text"=>"What is the most powerful piece in chess?",
      "correct_answer"=>"Queen",
      "options"=>["Queen", "King", "Knight", "Pawn"]}
      @question_2 = Question.new(data_2)

      correct_index = @question.options.index("Pon de Replay")
      correct_index_2 = @question.options.index("Queen")
      
      expect(correct_index == correct_index_2).to be(false)
    end
  end
end