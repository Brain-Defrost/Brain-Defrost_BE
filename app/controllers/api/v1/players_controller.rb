class Api::V1::PlayersController < ApplicationController
  before_action :accepting_players?, only: :create

  def index
    game = Game.find(params[:game_id])
    players = game.players
    broadcast_players_for(game)
    render json: PlayerSerializer.new(players)
  end

  def create
      player = @game.players.create!(player_params)
      players = @game.players.as_json(except: [:created_at, :updated_at])
      broadcast_players_for(@game)
      render json: PlayerSerializer.new(player), status: :created
  end

  def show
    player = Player.find_by!(game_id: params[:game_id], id: params[:id])
    render json: PlayerSerializer.new(player)
  end

  def update
    player = Player.find_by!(game_id: params[:game_id], id: params[:id])
    if params[:correct] == true
      player.update_correct_answers(params[:question])
    else
      player.update_incorrect_answers
    end
    player.save!
    broadcast_players_for(player.game)
    render json: PlayerSerializer.new(player)
  end

  def destroy
    player = Player.find_by!(game_id: params[:game_id], id: params[:id])
    player.destroy
  end

  private
  def accepting_players?
    @game = Game.find(params[:game_id])
    return render json: { error: { message: "Game started. New players may not join." } }, status: :forbidden if @game.started?
  
    if @game.players.count >= @game.number_of_players
      render json: { error: { message: "Max players reached. New players may not join." } }, status: :forbidden
    end
  end
  
  def player_params
    params.permit(:display_name)
  end

  def broadcast_players_for(game)
    players = game.players.as_json(except: [:created_at, :updated_at])
    ActionCable.server.broadcast("game_channel_#{game.id}", { player_list: players })
  end
end

