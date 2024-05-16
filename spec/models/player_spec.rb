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

  describe "instance methods" do
    before do
      game = create(:game)
      @player = Player.create!({display_name: "OP", game_id: game.id})
    end

    describe "#update_correct_answers" do
      it "updates questions_correct array and answers_correct integer" do
        @player.update_correct_answers(1)
        @player.update_correct_answers(2)

        expect(@player.questions_correct).to eq(["1", "2"])
        expect(@player.answers_correct).to eq(2)
      end

      it "doesn't display duplicate question numbers in the questions array" do
        expect(@player.questions_correct).to eq([])

        @player.update_correct_answers(1)
        @player.update_correct_answers(1)
        expect(@player.questions_correct).to eq(["1"])
        expect(@player.answers_correct).to eq(1)
      end
    end

    describe "#update_incorrect_answers" do
      it "updates answers_incorrect integer" do
        @player.update_incorrect_answers
        @player.update_incorrect_answers

        expect(@player.answers_incorrect).to eq(2)
        expect(@player.questions_correct).to eq([])
        expect(@player.answers_correct).to eq(0)
      end
    end
  end
end
