class Question
  attr_reader :topic,
              :question_number, 
              :question_text, 
              :answer, 
              :options

  def initialize(data)
    @topic = data["topic"]
    @question_number = data["id"]
    @question_text = data["question_text"]
    @answer = data["correct_answer"] 
    @options = data["options"]
  end
end