module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_player
    #designates a connection identifies that can bu used to find the specific connection later
    #anything marked as an identifier will automatically create a delegate by the same name on any channel instances created off the connection

    def connect
      self.current_player = find_verified_player
    end

    private

    def find_verified_player
      if verified_player = Player.find_by(game_id: params[:game_id], id: params[:id])
        verified_player
      else
        # built-in -> closes websocket connection if open and returns “unauthorized” reason. 
        reject_unauthorized_connection
      end
    end

    # identified_by :current_game
    # #designates a connection identifies that can bu used to find the specific connection later
    # #anything marked as an identifier will automatically create a delegate by the same name on any channel instances created off the connection

    # def connect
    #   self.game = find_verified_game
    # end

    # private

    # def find_verified_game
    #   if verified_game = Game.find_by(id: params[:game_id])
    #     verified_game
    #   else
    #     # built-in -> closes websocket connection if open and returns “unauthorized” reason. 
    #     reject_unauthorized_connection
    #   end
    # end
  end
end
