class Api::V1::StatsController < ApplicationController
  def show
    @game = Game.find(params[:game_id])
    stat_1 = Stat.create!(avg_correct_answers: calc_correct_answers(@game.id), game_id: @game.id)
    render json: StatSerializer.format(stat_1), status: :ok
  end

  def send_stat_email
    @game = Game.find(params[:game_id])
    if @game.stat.nil?
      @stat = Stat.create!(avg_correct_answers: calc_correct_answers(@game.id), game_id: @game.id)
    else
      @stat = @game.stat
    end

    recipient_email = params[:email]

    if recipient_email.blank?
      render json: { error: 'Email is required' }, status: :unprocessable_entity
    else
      StatSenderJob.perform_async(recipient_email, @stat.id)

      render json: { message: 'Stats sent successfully'}, status: :ok
    end
  end

  private
  def calc_correct_answers(game_id)
    Player.where(game_id: game_id).average(:answers_correct) * 100
  end
end