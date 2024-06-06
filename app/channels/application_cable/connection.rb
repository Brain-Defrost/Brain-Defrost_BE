module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_player

    def connect
      self.current_player = find_verified_player
    end

    private

    def find_verified_player
      if verified_player = Player.find_by(id: request.params[:player_id])
        verified_player
      else
        # built-in -> closes websocket connection if open and returns “unauthorized” reason.
        reject_unauthorized_connection
      end
    end
  end
end
