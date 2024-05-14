class Api::V1::GamesController < ApplicationController
  def create
    game = Game.create!(game_params)

    if game.save
      game.players.create!(display_name: params[:display_name])
      QuestionServiceFacade.get_questions(game)
    
      render json: GameSerializer.new(game)
    end
  end

  def show
  end

  def update
    #code
  end

  private
  def game_params
    params.require(:topic, :number_of_questions, :time_limit,:number_of_players, :display_name).permit(:id)
  end
end