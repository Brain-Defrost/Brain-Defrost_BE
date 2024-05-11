class Question
  attr_reader :id, :question, :correct_answer, :options

  def initialize(data)
    @id = data[:id]
    @question = data[:question]
    @correct_answer = data[:correct_answer] 
    @options = data[:options]
  end
end