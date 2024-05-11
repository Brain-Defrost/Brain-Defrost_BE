class Game < ApplicationRecord
  has_many :players, dependent: :destroy

  validates :topic, presence: true
  validates :number_of_questions, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 10 }
  validates :time_limit, presence: true, numericality: { greater_than_or_equal_to: 5, less_than_or_equal_to: 120 }
  validates :number_of_players, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 35 }
  validates :started, presence: true
  validates :link, presence: true, uniqueness: true
end
