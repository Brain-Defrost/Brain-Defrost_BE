class QuestionServiceFacade
  def self.get_questions(number, topic)
    service_response = QuestionService.new(number, topic).call

    parse_questions(service_response).map do |question_data|
      Question.new(question_data)
    end
  end

  def self.parse_questions(service_response)
    response = JSON.parse(service_response)
    questions = response["choices"].first["message"]["content"].split("\n\n")
    
    parsed_data = []
    
    questions.each do |question|
      id, body, correct_answer, options = question.scan(/(\d+)\. Question: (.+)\n\s+Correct Answer: (.+)\n\s+Options: \[(.+)\]/).flatten

      options = options.split(", ").map { |option| option.gsub(/["\[\]]/, '') }
      
      parsed_data << { id: id.to_i, question: body, correct_answer: correct_answer, options: options }
    end

    parsed_data
  end
end