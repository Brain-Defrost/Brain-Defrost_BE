require 'rails_helper'

RSpec.describe Player, type: :model do

  it { should validate_presence_of(:display_name) }
  it { should validate_length_of(:display_name).is_at_least(1).is_at_most(30) }
  it { should validate_presence_of(:answers_correct) }
  it { should validate_numericality_of(:answers_correct).is_greater_than_or_equal_to(0) }
  it { should validate_presence_of(:answers_incorrect) }
  it { should validate_numericality_of(:answers_incorrect).is_greater_than_or_equal_to(0) }
  it { should validate_presence_of(:game_id) }

  # Association test
  it { should belong_to(:game) }
end
