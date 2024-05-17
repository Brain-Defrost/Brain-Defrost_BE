class Api::V1::StatsController < ApplicationController
  def show
    @game = Game.find(params[:game_id])
    stat_1 = Stat.create!(avg_correct_answers: calc_correct_answers, game_id: @game.id)
    render json: StatSerializer.format(stat_1), status: :ok
  end

  private
  def calc_correct_answers
    @game.players.map { |player| player.answers_correct}.sum.to_f / (@game.number_of_questions.to_f * @game.players.count).to_f * 100
  end
end

