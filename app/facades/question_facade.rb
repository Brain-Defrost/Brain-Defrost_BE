class QuestionFacade
  def self.create_questions_for(game)
    trivia_question_config = {topic: game.topic, number_of_questions: game.number_of_questions}
    parsed_json = QuestionService.create_questions_for(trivia_question_config)
    if parsed_json.include?(:error)
      parsed_json
    else
      parsed_json[:data].map do |question_data|
        Question.new(question_data)
      end
    end
  end
end