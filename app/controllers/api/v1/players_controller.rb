class Api::V1::PlayersController < ApplicationController
  def create
    game = Game.find(params[:game_id])
    player = game.players.create!(player_params)
    render json: PlayerSerializer.new(player), status: :created
  end

  def show
    player = Player.find_by!(game_id: params[:game_id], id: params[:id])
    render json: PlayerSerializer.new(player)
  end

  def update
    player = Player.find_by!(game_id: params[:game_id])
    player.update!(player_params)
    render json: PlayerSerializer.new(player)
  end

  def destroy
    player = Player.find_by!(game_id: params[:game_id], id: params[:id])
    player.destroy
  end

  private
  def player_params
    params.permit(:display_name, :answers_correct, :answers_incorrect)
  end
end