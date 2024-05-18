require 'rails_helper'

RSpec.describe DeleteOldGamesJob, type: :job do
  describe '#perform' do
    let!(:recent_game) { create(:game, created_at: 30.minutes.ago) }
    let!(:old_game) { create(:game, created_at: 2.hours.ago) }

    it 'deletes games older than one hour' do
      expect(Game.count).to eq(2)

      DeleteOldGamesJob.perform_now

      expect(Game.exists?(old_game.id)).to be(false)
      expect(Game.exists?(recent_game.id)).to be(true)
    end
  end
end
