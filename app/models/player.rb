class Player < ApplicationRecord
  belongs_to :game
  
  validates :display_name, presence: true, length: { minimum: 1, maximum: 30 }, uniqueness: { scope: :game_id }
  validates_presence_of :display_name
  validates_uniqueness_of :display_name, scope: :game_id
  validates :answers_correct, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :answers_incorrect, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates_presence_of :game_id
end
