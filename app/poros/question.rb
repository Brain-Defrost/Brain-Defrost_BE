class Question
  attr_reader :topic,
              :question_number, 
              :question_text, 
              :answer, 
              :options

  def initialize(data)
    @topic = data["topic"]
    @question_number = data["id"]
    @question_text = fix_question(data["question_text"])
    @answer = data["correct_answer"]
    @options = complete_options(data).shuffle
  end

  def fix_question(data)
    data.sub(/^\d+\.\s/, "")
  end

  def complete_options(data)
    data["options"] << data["correct_answer"] unless data["options"].include?(data["correct_answer"])
    
    data["options"]
  end
end