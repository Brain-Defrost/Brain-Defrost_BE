class GameChannel < ApplicationCable::Channel
  def subscribed
    # require game_id
    return reject unless params[:game_id].present?

    # needs to be find_by and not find
    if game = Game.find_by(id: params[:game_id])
      stream_for game
    else
      reject
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
