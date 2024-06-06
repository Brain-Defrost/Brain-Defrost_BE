class Api::V1::GamesController < ApplicationController
  def create
    game = Game.new(new_game_params)
    if game.save!
      game.players.create!(display_name: params[:display_name])
      questions = QuestionFacade.create_questions_for(game)
      if questions.include?(:error)
        render json: questions, status: :internal_server_error
      else
        Rails.cache.write(game.id, questions, expires_in: 1.hour)

        # broadcast game status and players
        # GameChannel.broadcast_to(game, GameSerializer.format(game, questions))
        # head :created
        render json: GameSerializer.format(game, questions), status: :created
      end
    end
  end

  def show
    game = Game.find(params[:id])
    questions = Rails.cache.read(game.id)
    questions ||= []
    render json: GameSerializer.format(game, questions)
  end

  def update
    game = Game.find(params[:id])
    game.update!(game_params)
    questions = Rails.cache.read(game.id)
    questions ||= []
    render json: GameSerializer.format(game, questions)
  end

  private 
  def new_game_params
    params.permit(:topic, :number_of_questions, :number_of_players, :time_limit)
  end

  def game_params
    params.permit(:started)
  end
end
