class QuestionServiceFacade
  def self.get_questions(game)
    number = game.number_of_questions
    topic = game.topic

    service_response = QuestionService.new(number, topic).call

    parse_questions(service_response).map do |question_data|
      Question.new(question_data)
    end
  end
  
  def self.parse_questions(service_response)
    parsed_data = []
    if service_response.class == Hash
      
      questions = service_response["choices"].first["message"]["content"]
      
      questions.split("```json\n").reject(&:empty?).map do |json_string|
        parsed_data << JSON.parse("[#{json_string.gsub("```", "")}]")
      end
 
    else
      service_response = JSON.parse(service_response)
      
      questions = service_response["choices"].first["message"]["content"]
  
      questions.split("```json\n").reject(&:empty?).map do |json_string|
        parsed_data << JSON.parse(json_string.gsub("```", ""))
      end
    end
    parsed_data.flatten
  end
end