require 'rails_helper'

RSpec.describe GameChannel, type: :channel do
  it "successfully subscribes and streams game" do
    game = create(:game)
    subscribe game_id: game.id

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_for(game)
  end

  it "rejects subscription if game_id invalid" do
    subscribe game_id: 0
    expect(subscription).to be_rejected
  end

  it "rejects subscription if no game_id provided" do
    subscribe game_id: nil
    expect(subscription).to be_rejected
  end

  it "broadcasts game's players and status" do
    game = create(:game)
    create_list(:player, 2, game_id: game.id)
    players = game.players.as_json(except: [:created_at, :updated_at])

    expect{ subscribe game_id: game.id }.to have_broadcasted_to(game).with( { player_list: players, game_started: game.started} )
  end

  it "unsubscribing stops streams" do
    game = create(:game)

    subscribe game_id: game.id
    expect(subscription).to have_stream_for(game)

    unsubscribe
    expect(subscription).to_not have_streams
  end
end
