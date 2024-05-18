require 'rails_helper'

RSpec.describe Question do
  before do
    data = {"id"=>8,
    "topic"=>"Music Trivia",
    "question_text"=>"What is the name of Rihanna's debut single?",
    "correct_answer"=>"Pon de Replay",
    "options"=>["Umbrella", "Diamonds", "Love on the Brain", "Pon de Replay"]}
    
    data_2 = {"id"=>9,
    "topic"=>"Chess Trivia",
    "question_text"=>"What is the most powerful piece in chess?",
    "correct_answer"=>"Queen",
    "options"=>["Queen", "King", "Knight", "Pawn"]}
  
    data_incomplete = {"id"=>10,
    "topic"=>"Music Trivia",
    "question_text"=>"What is the name of Rihanna's debut single?",
    "correct_answer"=>"Pon de Replay",
    "options"=>["Umbrella", "Diamonds", "Love on the Brain"] }

    @question = Question.new(data)
    @question_2 = Question.new(data_2)
    @question_3 = Question.new(data_incomplete)
  end

  describe '#initialize' do
    it 'exists and populates attributes correctly' do
      expect(@question).to be_a(Question)
      expect(@question.question_number).to eq(8)
      expect(@question.topic).to eq("Music Trivia")
      expect(@question.question_text).to eq("What is the name of Rihanna's debut single?")
      expect(@question.answer).to eq("Pon de Replay")
      expect(@question.options).to be_an(Array)
    end
  end

  describe "instance methods" do
    it "#fix_question places the correct answer in a different location every time" do
      correct_index = @question.options.index("Pon de Replay")
      correct_index_2 = @question.options.index("Queen")
      
      expect(correct_index == correct_index_2).to be(false)
    end

    it "#complete_options adds the correct answer into the options in case the size of that array is less than 4" do
    
      expect(@question_3.options.length).to eq(4)
      expect(@question_3.options.include?("Pon de Replay")).to eq(true)
    end
  end
end