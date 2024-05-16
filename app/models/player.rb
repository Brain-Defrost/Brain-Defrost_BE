class Player < ApplicationRecord
  belongs_to :game

  validates :display_name, presence: true, length: { within: 1..30 }, uniqueness: { scope: :game_id }
  validates :answers_correct, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :answers_incorrect, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates_presence_of :game_id

  def update_correct_answers(question)
    self.questions_correct << question
    self.answers_correct += 1
  end

  def update_incorrect_answers
    self.answers_incorrect += 1
  end
end
