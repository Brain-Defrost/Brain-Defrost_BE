class Api::V1::PlayersController < ApplicationController
  before_action :accepting_players?, only: :create

  def index
    game = Game.find(params[:game_id])
    players = game.players
    render json: PlayerSerializer.new(players)
  end

  def create
      player = @game.players.create!(player_params)
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
end