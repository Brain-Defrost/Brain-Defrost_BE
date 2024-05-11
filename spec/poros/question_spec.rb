require 'rails_helper'

RSpec.describe Question do
  before do
    data = {:id=>1, :question=>"Who is known as the Queen of Pop?", :correct_answer=>"Madonna", :options=>["Madonna", "Beyonce", "Taylor Swift", "Adele"]}

    @question = Question.new(data)
  end

  describe '#initialize' do
    it 'exists and populates attributes correctly' do
      expect(@question).to be_a(Question)
      expect(@question.id).to eq(1)
      expect(@question.question).to eq("Who is known as the Queen of Pop?")
      expect(@question.correct_answer).to eq("Madonna")
      expect(@question.options).to eq(["Madonna", "Beyonce", "Taylor Swift", "Adele"])
    end
  end
end