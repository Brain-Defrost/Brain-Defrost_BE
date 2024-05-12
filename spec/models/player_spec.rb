require 'rails_helper'

RSpec.describe Player, type: :model do
  describe "validations" do
    let!(:player) { create(:player) }

    it { should validate_presence_of(:display_name) }
    it { should validate_length_of(:display_name).is_at_least(1).is_at_most(30) }
    it { should validate_uniqueness_of(:display_name).scoped_to(:game_id) }
    it { should validate_presence_of(:answers_correct) }
    it { should validate_numericality_of(:answers_correct).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:answers_incorrect) }
    it { should validate_numericality_of(:answers_incorrect).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:game_id) }
  end

  describe "associations" do
    it { should belong_to(:game) }
  end
end
