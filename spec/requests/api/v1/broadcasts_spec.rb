require "rails_helper"

RSpec.describe "ActionCable Broadcasts", type: :request do
  describe "Game's player list and status" do
    it "POST /api/v1/games broadcast", :vcr do
      body = { topic: "music", number_of_questions: 8, time_limit: 30, number_of_players: 7, display_name: "trivia_genius" }

      post "/api/v1/games", params: body

      game = Game.last
      players = game.players.as_json(except: [:created_at, :updated_at])

      expect {
        ActionCable.server.broadcast("game_channel_#{game.id}", { player_list: players, game_started: game.started })
      }.to have_broadcasted_to("game_channel_#{game.id}").with(
        player_list: players,
        game_started: game.started
      )
    end

    it "GET /api/v1/games/:id broadcast" do
      game = create(:game)
      create_list(:player, 2, game_id: game.id)
      players = game.players.as_json(except: [:created_at, :updated_at])

      get "/api/v1/games/#{game.id}"

      expect {
        ActionCable.server.broadcast("game_channel_#{game.id}", { player_list: players, game_started: game.started })
      }.to have_broadcasted_to("game_channel_#{game.id}").with(
        player_list: players,
        game_started: game.started
      )
    end

    it "PATCH /api/v1/games/:id broadcast" do
      game = create(:game)
      create_list(:player, 2, game_id: game.id)
      players = game.players.as_json(except: [:created_at, :updated_at])

      patch "/api/v1/games/#{game.id}", params: { started: true }
      game.update!(started: true)

      expect {
        ActionCable.server.broadcast("game_channel_#{game.id}", { player_list: players, game_started: game.started })
      }.to have_broadcasted_to("game_channel_#{game.id}").with(
        player_list: players,
        game_started: game.started
      )
    end
  end

  describe "Game's player list" do
    it "GET /api/v1/games/:id/players broadcast" do
      game = create(:game)
      create_list(:player, 2, game_id: game.id)
      players = game.players.as_json(except: [:created_at, :updated_at])

      get "/api/v1/games/#{game.id}/players"

      expect {
        ActionCable.server.broadcast("game_channel_#{game.id}", { player_list: players })
      }.to have_broadcasted_to("game_channel_#{game.id}").with(player_list: players)
    end

    it "POST /api/v1/games/:id/players broadcast" do
      game = create(:game)

      post "/api/v1/games/#{game.id}/players", params: { display_name: "person"}

      players = game.players.as_json(except: [:created_at, :updated_at])

      expect {
        ActionCable.server.broadcast("game_channel_#{game.id}", { player_list: players })
      }.to have_broadcasted_to("game_channel_#{game.id}").with(player_list: players)
    end

    it "PATCH /api/v1/games/:game_id/players/:id broadcast" do
      game = create(:game)
      player = create(:player, game_id: game.id)
      players = game.players.as_json(except: [:created_at, :updated_at])

      patch "/api/v1/games/#{game.id}", params: { question: 1, correct: true }

      expect {
        ActionCable.server.broadcast("game_channel_#{game.id}", { player_list: players })
      }.to have_broadcasted_to("game_channel_#{game.id}").with(player_list: players)
    end
  end
end
