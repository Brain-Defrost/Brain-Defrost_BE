class Question
  attr_reader :question_number, 
              :question_text, 
              :answer, 
              :options

  def initialize(data)
    @question_number = data[:attributes][:question_number]
    @question_text = data[:attributes][:question_text]
    @answer = data[:attributes][:answer]
    @options = data[:attributes][:options]
  end
end