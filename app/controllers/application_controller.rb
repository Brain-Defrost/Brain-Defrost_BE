class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :invalid

  def not_found(exception)
    if exception.message.include?("game_id")
      render json: { error: { message: "Couldn't find Player with 'id'=#{params[:id]} and 'game_id'=#{params[:game_id]}" } }, status: :not_found
    else
      render json: { error: { message: exception.message } }, status: :not_found
    end
  end

  def invalid(exception)
    if exception.message.include?("taken")
      render json: { error: { message: exception.message } }, status: :unprocessable_entity #422
    else
      render json: { error: { message: exception.message } }, status: :bad_request #400
    end
  end
end
