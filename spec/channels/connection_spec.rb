require "rails_helper"

RSpec.describe ApplicationCable::Connection, type: :channel do
  it "successfully connects with params" do
    player = create(:player)
    connect "/cable", params: { player_id: player.id }
    expect(connection.current_player).to eq player
  end

  it "rejects connection" do
    expect{ connect '/cable' }.to have_rejected_connection
    expect{ connect '/cable', params: { player_id: 0 } }.to have_rejected_connection
  end
end