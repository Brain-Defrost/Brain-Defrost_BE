require 'rails_helper'

RSpec.describe Game, type: :model do
  describe "validations" do
    it { should validate_presence_of(:topic) }
    it { should validate_length_of(:topic).is_at_most(50) }
    it { should validate_presence_of(:number_of_questions) }
    it { should validate_numericality_of(:number_of_questions).is_in(1..10) }
    it { should validate_presence_of(:time_limit) }
    it { should validate_numericality_of(:time_limit).is_in(5..120) }
    it { should validate_presence_of(:number_of_players) }
    it { should validate_numericality_of(:number_of_players).is_in(1..35) }

    it "validates 'started' is a boolean" do
      game_1 = create(:game, started: true)
      game_2 = create(:game, started: false)
      expect(game_1).to be_valid
      expect(game_2).to be_valid
    end
  end

  describe "associations" do
    it { should have_many(:players).dependent(:destroy) }
    it { should have_one(:stat).dependent(:destroy) }
  end
  
  describe "after_save block" do
      it "generates unique links upon creation" do
        game = Game.new({number_of_questions: 8, number_of_players: 7, topic: "music", time_limit: 30})
  
        game.save
        expect(game.link).to_not be_nil
      end
  
      it "generates a valid link with correct format" do
        game = Game.create!({number_of_questions: 8, number_of_players: 7, topic: "music", time_limit: 30})
  
        expect(game.link).to match("https://brain-defrost.github.io/Brain-Defrost_FE/join/#{game.id}")
      end
  end
end
