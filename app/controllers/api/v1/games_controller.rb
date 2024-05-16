class Api::V1::GamesController < ApplicationController
  def create
    game = Game.new(new_game_params)
    if game.save!
      game.players.create!(display_name: params[:display_name])
      questions = QuestionServiceFacade.get_questions(game)
      render json: GameSerializer.format(game, questions), status: :created
    end
  end

  def show
    game = Game.find(params[:id])
    render json: GameSerializer.format(game)
  end

  def update
    game = Game.find(params[:id])
    game.update!(game_params)
    render json: GameSerializer.format(game)
  end

  private
  def new_game_params
    params.permit(:topic, :number_of_questions, :number_of_players, :time_limit)
  end

  def game_params
    params.permit(:started)
  end
end