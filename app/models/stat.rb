class Stat < ApplicationRecord
  belongs_to :game

  validates :game_id, presence: true
  validates :avg_correct_answers, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
