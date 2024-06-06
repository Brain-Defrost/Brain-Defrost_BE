require 'rails_helper'

RSpec.describe GameChannel, type: :channel do
  it "successfully subscribes and streams game" do
    game = create(:game)
    subscribe game_id: game.id

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_for(game)
  end

  it "rejects subscription" do
    subscribe game_id: nil
    expect(subscription).to be_rejected

    subscribe game_id: 0
    expect(subscription).to be_rejected
  end

  it "unsubscribing stops streams" do
    game = create(:game)
    subscribe game_id: game.id
    expect(subscription).to have_stream_for(game)

    unsubscribe
    expect(subscription).to_not have_stream_for(game)
  end

  it "broadcasts game" do
    game = create(:game)
    create_list(:player, 2, game_id: game.id)
    subscribe game_id: game.id

    data = GameSerializer.format(game)

    expect{ GameChannel.broadcast_to(game, data) }.to have_broadcasted_to(game).with(data)
  end
end
