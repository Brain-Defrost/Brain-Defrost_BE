# spec/models/game_spec.rb
require 'rails_helper'

RSpec.describe Game, type: :model do
  # Validation tests
  it { should validate_presence_of(:topic) }
  it { should validate_presence_of(:number_of_questions) }
  it { should validate_numericality_of(:number_of_questions).is_greater_than(0).is_less_than_or_equal_to(10) }
  it { should validate_presence_of(:time_limit) }
  it { should validate_numericality_of(:time_limit).is_greater_than_or_equal_to(5).is_less_than_or_equal_to(120) }
  it { should validate_presence_of(:number_of_players) }
  it { should validate_numericality_of(:number_of_players).is_greater_than(0).is_less_than_or_equal_to(35) }
  it { should validate_presence_of(:started) }
  it { should validate_presence_of(:link) }

  # Association tests
  it { should have_many(:players).dependent(:destroy) }
  # Remove the line below if Stats model doesn't exist
end
