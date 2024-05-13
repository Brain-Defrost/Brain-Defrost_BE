class QuestionServiceFacade
  def self.get_questions(number, topic)
    service_response = QuestionService.new(number, topic).call

    parse_questions(service_response).map do |question_data|
      Question.new(question_data)
    end
  end

  def self.parse_questions(service_response)
    response = JSON.parse(service_response)
    questions = response["choices"].first["message"]["content"]
    
    parsed_data = []

    questions.split("```json\n").reject(&:empty?).map do |json_string|
      parsed_data << JSON.parse(json_string.gsub("```", ""))
    end
    parsed_data
  end
end