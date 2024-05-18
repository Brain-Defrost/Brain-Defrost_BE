require 'rails_helper'

RSpec.describe Question do

  before do
    data = {
      id: nil, 
      type: "question", 
      attributes: {
        question_text: "Who is the Doctor's main nemesis?",
        question_number: "1", 
        answer: "The Master", 
        options: 
        ["Cybermen", "The Master", "Daleks", "Silence"]
      }
    }

    @question = Question.new(data)
  end

  describe '#initialize' do
    it 'exists and populates attributes correctly' do
      require 'pry'; binding.pry
      expect(@question).to be_a(Question)
      expect(@question.question_number).to eq("1")
      expect(@question.question_text).to eq("Who is the Doctor's main nemesis?")
      expect(@question.answer).to eq("The Master")
      expect(@question.options).to be_an(Array)
      expect(@questions.options).to include("Cybermen", "The Master", "Daleks", "Silence")
    end
  end
end