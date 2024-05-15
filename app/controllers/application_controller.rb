class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :error_message
  rescue_from ActiveRecord::RecordInvalid, with: :error_message

  def error_message(exception)
    if exception.message.include?("exist") || exception.message.include?("find")
      render json: { error: { message: exception.message } }, status: :not_found #404
    else
      render json: { error: { message: exception.message } }, status: :bad_request #400
    end
  end
end
