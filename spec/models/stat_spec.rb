require 'rails_helper'

RSpec.describe Stat, type: :model do

  it { should validate_presence_of(:game_id) }
  it { should validate_numericality_of(:avg_correct_answers).is_greater_than_or_equal_to(0) }

  # Association test
  it { should belong_to(:game) }
end
