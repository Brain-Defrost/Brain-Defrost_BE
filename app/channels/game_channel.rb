class GameChannel < ApplicationCable::Channel
  def subscribed
    return reject unless params[:game_id].present?

    if game = Game.find_by(id: params[:game_id])
      stream_for game
      players = game.players.as_json(except: [:created_at, :updated_at])
      GameChannel.broadcast_to(game, { player_list: players, game_started: game.started })
    else
      reject
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
