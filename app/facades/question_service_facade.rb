class QuestionServiceFacade
  def self.get_questions(game)
    number = game.number_of_questions
    topic = game.topic

    service_response = QuestionService.new(number, topic).call

    parse_questions(service_response).map do |question_data|
      Question.new(question_data)
    end
  end

  def self.parse_questions(response)
    response = JSON.parse(response) if response.is_a?(String)
  
    questions = response["choices"].first["message"]["content"]
    json_strings = questions.split("```json\n").reject(&:empty?)
  
    parsed_data = json_strings.map do |json_string|
      json_string = "[#{json_string.gsub("\n\n", ",")}]" if json_string.include?("\n\n") && !json_string.include?("```")
      JSON.parse(json_string.gsub("```", ""))
    end
  
    parsed_data.flatten
  end
end