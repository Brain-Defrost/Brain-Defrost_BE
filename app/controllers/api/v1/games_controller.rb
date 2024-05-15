class Api::V1::GamesController < ApplicationController
  def create
    game = Game.new(new_game_params)
    if game.save!
      game.players.create!(display_name: params[:display_name])
      questions = QuestionServiceFacade.get_questions(game)
      render json: GameSerializer.new(game, questions), status: :created
    end
  end

  def show
    game = Game.find(params[:id])
    render json: GameSerializer.new(game)
  end

  def update
    game = Game.find(params[:id])
    game.update!(started: params[:started])
    render json: GameSerializer.new(game)
  end

  private
  def new_game_params
    params.permit(:topic, :number_of_questions, :number_of_players, :time_limit, :link) # remove link later
  end

  def game_params
    params.permit(:started)
  end
end