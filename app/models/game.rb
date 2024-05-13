class Game < ApplicationRecord
  has_many :players, dependent: :destroy

  validates :topic, presence: true, length: { maximum: 50 }
  validates :number_of_questions, presence: true, numericality: { in: 1..10 }
  validates :time_limit, presence: true, numericality: { in: 5..120 }
  validates :number_of_players, presence: true, numericality: { in: 1..35 }
  validates :link, presence: true, uniqueness: true
  validates :started, inclusion: [true, false]
end
