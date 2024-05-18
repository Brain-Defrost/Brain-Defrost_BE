require 'rails_helper'

RSpec.describe QuestionFacade do
  describe ".create_questions_for(game)" do
    it "creates Questions given parsed question data", :vcr do
      game = create(:game, topic: "doctor who", number_of_questions: 5)
      questions = QuestionFacade.create_questions_for(game)

      if questions.include?(:error)
        expect(questions[:error][:message]).to be_a String
      else
        expect(questions).to all(be_a(Question))
      end
    end
  end
end